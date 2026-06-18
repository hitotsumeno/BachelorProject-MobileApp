import 'package:flutter/material.dart';

enum EquipmentSlot {
  hairstyle,
  glasses,
  headPhones,
  shirt,
  outwear,
  gloves,
  pants,
  shoe,
  head,
  chest,
  weapon,
  offHand,
}

extension EquipmentSlotX on EquipmentSlot {
  String get label {
    switch (this) {
      case EquipmentSlot.hairstyle:
        return 'Hairstyle';
      case EquipmentSlot.glasses:
        return 'Glasses';
      case EquipmentSlot.headPhones:
        return 'Headphones';
      case EquipmentSlot.shirt:
        return 'Shirt';
      case EquipmentSlot.outwear:
        return 'Outerwear';
      case EquipmentSlot.gloves:
        return 'Gloves';
      case EquipmentSlot.pants:
        return 'Pants';
      case EquipmentSlot.shoe:
        return 'Shoes';
      case EquipmentSlot.head:
        return 'Head';
      case EquipmentSlot.chest:
        return 'Chest';
      case EquipmentSlot.weapon:
        return 'Weapon';
      case EquipmentSlot.offHand:
        return 'Off-hand';
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentSlot.hairstyle:
        return Icons.content_cut;
      case EquipmentSlot.glasses:
        return Icons.visibility;
      case EquipmentSlot.headPhones:
        return Icons.headphones;
      case EquipmentSlot.shirt:
        return Icons.checkroom;
      case EquipmentSlot.outwear:
        return Icons.dry_cleaning;
      case EquipmentSlot.gloves:
        return Icons.back_hand;
      case EquipmentSlot.pants:
        return Icons.airline_seat_legroom_normal;
      case EquipmentSlot.shoe:
        return Icons.do_not_step;
      case EquipmentSlot.head:
        return Icons.face_retouching_natural;
      case EquipmentSlot.chest:
        return Icons.accessibility_new;
      case EquipmentSlot.weapon:
        return Icons.flash_on;
      case EquipmentSlot.offHand:
        return Icons.shield_outlined;
    }
  }
}

class EquipmentItem {
  final String id;
  final String name;
  final String assetPath;
  final EquipmentSlot slot;
  final IconData icon;

  const EquipmentItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.slot,
    required this.icon,
  });

  bool get isNone => assetPath.isEmpty;
}


class SkinOption {
  final String id;
  final String name;
  final String assetPath;

  const SkinOption({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}

class CharacterAssetRegistry {
  const CharacterAssetRegistry._();

  static const String _skinsDir = 'assets/character/skins/';
  static const String _equipmentDir = 'assets/character/equipment/';

  static const List<SkinOption> skins = [
    SkinOption(
      id: 'default',
      name: 'Default',
      assetPath: '${_skinsDir}default.glb',
    ),
    SkinOption(
      id: 'warrior',
      name: 'Warrior',
      assetPath: '${_skinsDir}warrior.glb',
    ),
    SkinOption(
      id: 'mage',
      name: 'Mage',
      assetPath: '${_skinsDir}mage.glb',
    ),
  ];

  static EquipmentItem _e(
    EquipmentSlot slot,
    String id,
    String name,
    IconData icon, {
    String? assetPath,
  }) {
    return EquipmentItem(
      id: id,
      name: name,
      assetPath: assetPath ?? '$_equipmentDir$id.glb',
      slot: slot,
      icon: icon,
    );
  }

  static EquipmentItem _noneFor(EquipmentSlot slot) => EquipmentItem(
        id: '',
        name: 'None',
        assetPath: '',
        slot: slot,
        icon: Icons.not_interested,
      );

  static final List<EquipmentItem> _items = [
    // Hair / face
    _e(EquipmentSlot.hairstyle, 'hairstyle_male_010', 'Short', Icons.content_cut),
    _e(EquipmentSlot.hairstyle, 'hairstyle_male_012', 'Long', Icons.brush),
    _e(EquipmentSlot.glasses, 'glasses_004', 'Round', Icons.circle_outlined),
    _e(EquipmentSlot.glasses, 'glasses_006', 'Sunglasses', Icons.wb_sunny),
    _e(EquipmentSlot.headPhones, 'headphones_002', 'Headphones', Icons.headphones),

    // Upper body
    _e(EquipmentSlot.shirt, 't_shirt_009', 'T-Shirt', Icons.checkroom),
    _e(EquipmentSlot.outwear, 'outwear_029', 'Jacket', Icons.dry_cleaning),
    _e(EquipmentSlot.outwear, 'outwear_036', 'Hoodie', Icons.dry_cleaning_outlined),
    _e(EquipmentSlot.gloves, 'gloves_014', 'Leather', Icons.back_hand),
    _e(EquipmentSlot.gloves, 'gloves_006', 'Combat', Icons.front_hand),

    // Lower body
    _e(EquipmentSlot.pants, 'pants_010', 'Cargo Jeans', Icons.airline_seat_legroom_normal),
    _e(EquipmentSlot.pants, 'pants_015', 'Combat', Icons.airline_seat_legroom_extra),
    _e(EquipmentSlot.pants, 'shorts_003', 'Shorts', Icons.beach_access),
    _e(EquipmentSlot.shoe, 'shoe_sneakers_009', 'Sneakers', Icons.directions_run),
    _e(EquipmentSlot.shoe, 'shoe_slippers_002', 'Slippers', Icons.bedtime),
    _e(EquipmentSlot.shoe, 'shoe_slippers_005', 'Slides', Icons.beach_access),

    // Head accessories
    _e(EquipmentSlot.head, 'hat_010', 'Cap', Icons.sports_baseball),
    _e(EquipmentSlot.head, 'hat_049', 'Beanie', Icons.ac_unit),
    _e(EquipmentSlot.head, 'hat_057', 'Top Hat', Icons.stars),
  ];

  /// Slot ordered list of items. Each list begins with the "None" option,
  /// followed by every entry in `_items` for that slot in declaration order.
  /// Built once on first access and cached.
  static final Map<EquipmentSlot, List<EquipmentItem>> equipment =
      _buildEquipmentMap();

  static Map<EquipmentSlot, List<EquipmentItem>> _buildEquipmentMap() {
    final map = <EquipmentSlot, List<EquipmentItem>>{
      for (final slot in EquipmentSlot.values) slot: [_noneFor(slot)],
    };
    for (final item in _items) {
      map[item.slot]!.add(item);
    }
    return Map<EquipmentSlot, List<EquipmentItem>>.unmodifiable({
      for (final entry in map.entries)
        entry.key: List<EquipmentItem>.unmodifiable(entry.value),
    });
  }

  static const List<Color> colorPalette = [
    Color(0xFF7C4DFF), // purple (default)
    Color(0xFF2196F3), // blue
    Color(0xFF4CAF50), // green
    Color(0xFFF44336), // red
    Color(0xFFFF9800), // orange
    Color(0xFF00BCD4), // cyan
    Color(0xFFFFC107), // amber
    Color(0xFF9C27B0), // deep purple
    Color(0xFF607D8B), // blue-grey
    Color(0xFF795548), // brown
  ];

  static SkinOption skinById(String id) {
    return skins.firstWhere(
      (s) => s.id == id,
      orElse: () => skins.first,
    );
  }

  static List<EquipmentItem> itemsForSlot(EquipmentSlot slot) {
    return equipment[slot] ?? const [];
  }

  static EquipmentItem itemById(EquipmentSlot slot, String id) {
    final items = itemsForSlot(slot);
    return items.firstWhere(
      (e) => e.id == id,
      orElse: () => items.first, // falls back to the "None" option
    );
  }
}
