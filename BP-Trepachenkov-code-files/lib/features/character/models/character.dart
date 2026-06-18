import 'dart:math';
import 'package:isar/isar.dart';

part 'character.g.dart';

@Collection()
class Character {
  Id id = 1; // singleton — always use id 1

  String name = 'Hero';
  int level = 1;
  int currentXP = 0;
  int currentHealth = 100;
  int maxHealth = 100;
  int mana = 50;
  int maxMana = 50;
  int gold = 0;

  // --- 3D character customization ---
  // selectedSkinId maps to an entry in CharacterAssetRegistry.skins.
  // accentColorValue is an ARGB int usable directly with Color(...).
  // equippedItemsJson is a JSON-encoded Map<String, String> of
  //   slotName -> itemId (e.g. {"head":"helmet_iron","weapon":"sword_iron"}).
  // Slots not present in the map are unequipped. This shape lets us add new
  // EquipmentSlot values without touching the schema.
  String selectedSkinId = 'default';
  int accentColorValue = 0xFF7C4DFF;
  String equippedItemsJson = '{}';

  @ignore
  int get xpToNextLevel => max(1, (100 * level * 1.5).round());

  @ignore
  bool get isDead => currentHealth <= 0;

  @ignore
  double get healthPercent => maxHealth > 0 ? currentHealth / maxHealth : 0;

  @ignore
  double get xpPercent => currentXP / xpToNextLevel;

  @ignore
  double get manaPercent => maxMana > 0 ? mana / maxMana : 0;
}
