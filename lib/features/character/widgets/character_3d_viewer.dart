import 'dart:convert';
import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/character/models/character_customization.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';

/// Renders the character as a Three.js scene inside an [InAppWebView].
///
/// The HTML/JS loads `assets/character/viewer/viewer.html`. The skin (body)
/// and each equipment slot are pushed into the same scene as separate GLBs,
/// so the user can mix-and-match gear without per-layer drift.
///
/// On every rebuild the widget compares the character's current selections
/// against what was last pushed to the WebView and sends only the deltas.
/// HP / XP / mana changes therefore do **not** cause GLB reloads.
class Character3DViewer extends StatefulWidget {
  const Character3DViewer({
    super.key,
    required this.accentColor,
    this.height = 320,
  });

  final Color accentColor;
  final double height;

  @override
  State<Character3DViewer> createState() => _Character3DViewerState();
}

class _Character3DViewerState extends State<Character3DViewer> {
  InAppWebViewController? _controller;
  bool _sceneReady = false;
  bool _bodyMissing = false;
  String? _missingBodyPath;

  // Last values pushed to the WebView. Used to diff before sending updates.
  String _lastBodyPath = '';
  final Map<EquipmentSlot, String> _lastEquipmentPath = {};

  // Cache of base64-encoded GLB bytes per asset path. Loading 1–2 MB GLBs
  // off the asset bundle is cheap, but the base64 encode is not free, so we
  // hang on to the result for repeat selections (e.g. user toggling between
  // two skins). Empty string means "asset not present on disk".
  final Map<String, String> _glbBase64Cache = {};

  static final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    transparentBackground: true,
    // Allow the file:// page to fetch sibling file:// GLBs. Without these
    // the GLTFLoader's XHR is blocked by the WebView's same-origin policy.
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    supportZoom: false,
    // NOTE: do NOT set disableHorizontal/VerticalScroll — those install a
    // native OnTouchListener that eats pointer events before OrbitControls
    // can see them. The page itself already pins layout via
    // `overflow: hidden` + `touch-action: none` on the canvas.
    useHybridComposition: true,
  );

  /// Returns base64-encoded GLB bytes for [path], or an empty string if the
  /// asset isn't bundled. Results are cached in [_glbBase64Cache].
  Future<String> _loadGlbBase64(String path) async {
    if (path.isEmpty) return '';
    final cached = _glbBase64Cache[path];
    if (cached != null) return cached;
    try {
      final data = await rootBundle.load(path);
      final encoded = base64Encode(data.buffer.asUint8List());
      _glbBase64Cache[path] = encoded;
      return encoded;
    } catch (_) {
      _glbBase64Cache[path] = '';
      return '';
    }
  }

  Future<void> _pushSlot(String slotName, String base64) async {
    final controller = _controller;
    if (controller == null) return;
    // callAsyncJavaScript passes large arguments as proper JS values rather
    // than splicing them into a source string, which keeps the bridge from
    // blowing up on multi-MB base64 payloads.
    await controller.callAsyncJavaScript(
      functionBody:
          'window.viewerSetEquipment(slot, base64); return true;',
      arguments: {'slot': slotName, 'base64': base64},
    );
  }

  Future<void> _pushBody(String base64) async {
    final controller = _controller;
    if (controller == null) return;
    await controller.callAsyncJavaScript(
      functionBody: 'window.viewerSetBody(base64); return true;',
      arguments: {'base64': base64},
    );
  }

  void _onJsMessage(List<dynamic> args) {
    if (args.isEmpty || !mounted) return;
    final raw = args.first;
    final Map<String, dynamic> data = raw is Map<String, dynamic>
        ? raw
        : (raw is String ? jsonDecode(raw) as Map<String, dynamic> : const {});
    final type = data['type'] as String?;
    if (type == 'ready') {
      setState(() => _sceneReady = true);
      _syncToWebView();
    } else if (type == 'slot_loaded') {
      final slot = data['slot'] as String?;
      final ok = data['ok'] as bool? ?? false;
      if (slot == 'body' && mounted) {
        setState(() {
          _bodyMissing = !ok;
          if (ok) _missingBodyPath = null;
        });
      }
    }
  }

  /// Pushes any pending body / equipment changes to the WebView. Idempotent —
  /// safe to call on every build.
  Future<void> _syncToWebView() async {
    if (_controller == null || !_sceneReady || !mounted) return;

    final notifier = context.read<CharacterNotifier>();
    final character = notifier.character;

    // Body / skin
    final skin = CharacterAssetRegistry.skinById(character.selectedSkinId);
    if (skin.assetPath != _lastBodyPath) {
      _lastBodyPath = skin.assetPath;
      final base64 = await _loadGlbBase64(skin.assetPath);
      if (!mounted) return;
      await _pushBody(base64);
      if (mounted) {
        setState(() {
          _bodyMissing = base64.isEmpty;
          _missingBodyPath = base64.isEmpty ? skin.assetPath : null;
        });
      }
    }

    // Each equipment slot
    for (final slot in EquipmentSlot.values) {
      final id = notifier.equippedIdFor(slot);
      final item = CharacterAssetRegistry.itemById(slot, id);
      final path = item.isNone ? '' : item.assetPath;
      if (_lastEquipmentPath[slot] == path) continue;
      _lastEquipmentPath[slot] = path;

      // Missing equipment GLBs are silently skipped (empty payload = unequip).
      final base64 = await _loadGlbBase64(path);
      if (!mounted) return;
      await _pushSlot(slot.name, base64);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the notifier so this widget rebuilds when the user changes any
    // selection in the customization panel.
    context.watch<CharacterNotifier>();
    // After the build commits, diff and push deltas (no-op if nothing changed).
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncToWebView());

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.accentColor.withValues(alpha: 0.15),
            Colors.grey.shade100,
          ],
        ),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InAppWebView(
            initialFile: 'assets/character/viewer/viewer.html',
            initialSettings: _settings,
            // Claim pan + scale gestures so the parent SingleChildScrollView
            // doesn't swallow them — required for OrbitControls (rotate/zoom)
            // to actually receive touch input.
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
              Factory<HorizontalDragGestureRecognizer>(
                  () => HorizontalDragGestureRecognizer()),
              Factory<ScaleGestureRecognizer>(
                  () => ScaleGestureRecognizer()),
              Factory<TapGestureRecognizer>(
                  () => TapGestureRecognizer()),
            },
            onWebViewCreated: (controller) {
              _controller = controller;
              controller.addJavaScriptHandler(
                handlerName: 'viewer',
                callback: _onJsMessage,
              );
            },
          ),
          if (!_sceneReady)
            Center(
              child: CircularProgressIndicator(color: widget.accentColor),
            ),
          if (_sceneReady && _bodyMissing)
            Positioned.fill(
              child: _MissingBodyOverlay(
                accentColor: widget.accentColor,
                assetPath: _missingBodyPath ?? '',
              ),
            ),
        ],
      ),
    );
  }
}

class _MissingBodyOverlay extends StatelessWidget {
  const _MissingBodyOverlay({
    required this.accentColor,
    required this.assetPath,
  });

  final Color accentColor;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.85),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.view_in_ar_outlined,
            size: 56,
            color: accentColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            'Character body model not found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Drop a GLB file at:\n$assetPath',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
