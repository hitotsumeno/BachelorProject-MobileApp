// Character viewer — single Three.js scene that hosts the body GLB plus any
// number of equipment GLBs as siblings under a shared origin. Equipment GLBs
// are assumed to be authored to fit the body at origin (no per-bone binding).
//
// Public API exposed on `window`:
//   viewerSetBody(assetPath)               -> swap the skin/body model
//   viewerSetEquipment(slot, assetPath)    -> attach (or replace) a piece
//                                             of equipment in `slot`. Pass
//                                             empty string to unequip.
//   viewerClearAll()                       -> drop every model from the scene
//
// Messages posted back to Flutter via the `viewer` JavaScript handler
// registered by flutter_inappwebview. Each call is a single object argument:
//   { type: 'ready' }                                  // scene constructed
//   { type: 'slot_loaded',  slot, ok: true,  empty? } // GLB in / cleared
//   { type: 'slot_loaded',  slot, ok: false, error  } // load failed

import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

// --- GLB byte transport ---------------------------------------------------
// Modern Chromium (Android WebView) hard-blocks fetch() against file:// URLs
// regardless of allowFileAccessFromFileURLs settings, so Three.js's URL-based
// loader can't read GLBs from the Flutter asset bundle directly. Instead the
// Flutter side reads the bytes from rootBundle, base64-encodes them, and
// hands them to viewerSetBody / viewerSetEquipment. Here we decode the
// base64 to an ArrayBuffer and run it through GLTFLoader.parse().
function base64ToArrayBuffer(b64) {
  const bin = atob(b64);
  const len = bin.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) bytes[i] = bin.charCodeAt(i);
  return bytes.buffer;
}

// --- Flutter bridge -------------------------------------------------------
// flutter_inappwebview injects `window.flutter_inappwebview` once the page
// loads. Calls before that are buffered into `pendingMessages` and flushed
// in order as soon as the bridge becomes available.
const pendingMessages = [];

function flushPending() {
  if (!window.flutter_inappwebview || !window.flutter_inappwebview.callHandler) return;
  while (pendingMessages.length > 0) {
    const msg = pendingMessages.shift();
    window.flutter_inappwebview.callHandler('viewer', msg);
  }
}

function notifyFlutter(message) {
  if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
    flushPending();
    window.flutter_inappwebview.callHandler('viewer', message);
  } else {
    pendingMessages.push(message);
    // Poll briefly until the bridge is ready, then drain the queue.
    setTimeout(flushPending, 50);
  }
}

// --- Status overlay -------------------------------------------------------
const statusEl = document.getElementById('status');
function showStatus(msg) {
  if (!statusEl) return;
  statusEl.textContent = msg;
  statusEl.classList.add('visible');
}
function clearStatus() {
  if (!statusEl) return;
  statusEl.textContent = '';
  statusEl.classList.remove('visible');
}

// --- Scene setup ----------------------------------------------------------
const scene = new THREE.Scene();

// Far plane is generous so weird-scaled GLBs don't get clipped before we
// have a chance to auto-frame them.
const camera = new THREE.PerspectiveCamera(
  35,
  window.innerWidth / window.innerHeight,
  0.01,
  10000,
);
camera.position.set(0, 1.4, 3.2);

const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.outputColorSpace = THREE.SRGBColorSpace;
document.body.appendChild(renderer.domElement);

// Lighting: soft ambient + key light + subtle fill so unlit-ish GLBs still read.
scene.add(new THREE.AmbientLight(0xffffff, 0.65));

const keyLight = new THREE.DirectionalLight(0xffffff, 1.0);
keyLight.position.set(2, 4, 3);
scene.add(keyLight);

const fillLight = new THREE.DirectionalLight(0xffffff, 0.35);
fillLight.position.set(-3, 2, -1);
scene.add(fillLight);

// Orbit controls — touch-friendly, clamped to keep the model on-screen.
const controls = new OrbitControls(camera, renderer.domElement);
controls.target.set(0, 1.0, 0);
controls.enableDamping = true;
controls.dampingFactor = 0.08;
controls.enablePan = false;
controls.minPolarAngle = 0.2;
controls.maxPolarAngle = Math.PI - 0.2;
// minDistance/maxDistance are recomputed from the body's bounding box once
// it loads — see frameBody().
controls.update();

// --- Slot management ------------------------------------------------------
// Each slot ('body', 'head', 'chest', 'weapon', 'offHand', ...) holds one
// loaded gltf.scene. Setting a slot disposes the previous mesh first.
const loader = new GLTFLoader();
const slots = new Map();

function disposeObject(obj) {
  obj.traverse((node) => {
    if (node.geometry) node.geometry.dispose();
    if (node.material) {
      const mats = Array.isArray(node.material) ? node.material : [node.material];
      for (const m of mats) {
        for (const k of Object.keys(m)) {
          const v = m[k];
          if (v && v.isTexture) v.dispose();
        }
        m.dispose();
      }
    }
  });
}

function clearSlot(slot) {
  const existing = slots.get(slot);
  if (!existing) return;
  if (existing.parent) existing.parent.remove(existing);
  disposeObject(existing);
  slots.delete(slot);
}

// Frames the camera to the current body so it always lands on screen,
// regardless of the GLB's authoring scale or origin. Also doubles as the
// "ground" reference: the body's lowest point is moved to y = 0.
function frameBody() {
  const body = slots.get('body');
  if (!body) return;

  const bbox = new THREE.Box3().setFromObject(body);
  if (!isFinite(bbox.min.x) || bbox.isEmpty()) return;

  const size = bbox.getSize(new THREE.Vector3());
  const center = bbox.getCenter(new THREE.Vector3());

  // Center horizontally + plant feet on y=0. Equipment GLBs that follow the
  // same authoring convention will line up automatically.
  body.position.x -= center.x;
  body.position.z -= center.z;
  body.position.y -= bbox.min.y;

  // Re-parent any equipment that loaded before the body so it inherits this
  // offset. New equipment is parented to the body in setSlot() directly.
  for (const [slotName, obj] of slots) {
    if (slotName !== 'body' && obj.parent !== body) {
      body.add(obj);
    }
  }

  // Re-measure after moving so camera math uses the final size.
  const fitHeight = size.y;
  const fitRadius = Math.max(size.x, size.z) * 0.5;
  const fov = camera.fov * (Math.PI / 180);
  const distH = fitHeight / (2 * Math.tan(fov / 2));
  const distR = fitRadius / (2 * Math.tan(fov / 2) * camera.aspect);
  const distance = Math.max(distH, distR) * 2.5; // padding so the model isn't edge-to-edge

  const targetY = fitHeight * 4.3;
  controls.target.set(0, targetY, 0);
  camera.position.set(0, targetY, distance);
  camera.near = Math.max(distance / 100, 0.01);
  camera.far = distance * 100;
  camera.updateProjectionMatrix();

  controls.minDistance = distance * 0.4;
  controls.maxDistance = distance * 3.0;
  controls.update();
}

function setSlot(slot, base64) {
  clearSlot(slot);
  if (!base64) {
    notifyFlutter({ type: 'slot_loaded', slot, ok: true, empty: true });
    if (slot === 'body') showStatus('No body model set.');
    return;
  }
  let buffer;
  try {
    buffer = base64ToArrayBuffer(base64);
  } catch (e) {
    const msg = e && e.message ? e.message : String(e);
    if (slot === 'body') showStatus('Failed to decode body GLB:\n' + msg);
    notifyFlutter({ type: 'slot_loaded', slot, ok: false, error: msg });
    return;
  }
  loader.parse(
    buffer,
    '',
    (gltf) => {
      const root = gltf.scene;
      slots.set(slot, root);
      // Parent equipment to the body so it inherits the body's centering /
      // ground offset. If the body isn't loaded yet, fall back to the scene;
      // frameBody() will re-parent on body load.
      const body = slots.get('body');
      const parent = (slot === 'body' || !body) ? scene : body;
      parent.add(root);
      if (slot === 'body') {
        frameBody();
        clearStatus();
      }
      notifyFlutter({ type: 'slot_loaded', slot, ok: true });
    },
    (err) => {
      const msg = (err && err.message) ? err.message : String(err);
      if (slot === 'body') showStatus('Failed to parse body GLB:\n' + msg);
      notifyFlutter({ type: 'slot_loaded', slot, ok: false, error: msg });
    },
  );
}

// --- Public API -----------------------------------------------------------
window.viewerSetBody = (assetPath) => setSlot('body', assetPath);
window.viewerSetEquipment = (slot, assetPath) => setSlot(slot, assetPath);
window.viewerClearAll = () => {
  for (const slot of Array.from(slots.keys())) clearSlot(slot);
};

// --- Resize + render loop -------------------------------------------------
window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
});

function animate() {
  requestAnimationFrame(animate);
  controls.update();
  renderer.render(scene, camera);
}
animate();

notifyFlutter({ type: 'ready' });
