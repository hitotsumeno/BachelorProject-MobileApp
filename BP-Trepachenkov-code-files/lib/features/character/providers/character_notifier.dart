import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:bp_flutter_app/features/character/models/character.dart';
import 'package:bp_flutter_app/features/character/models/character_customization.dart';
import 'package:bp_flutter_app/core/services/isar_service.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';
import 'package:bp_flutter_app/features/tasks/models/task_reward.dart';

class CharacterNotifier extends ChangeNotifier {
  final Isar _isar = IsarService.isar;
  Character _character = Character();

  Character get character => _character;

  // Reward / damage constants — easy to tune in one place
  static const Map<TaskDifficulty, int> xpRewards = {
    TaskDifficulty.easy: 20,
    TaskDifficulty.medium: 50,
    TaskDifficulty.hard: 100,
  };

  static const Map<TaskDifficulty, int> goldRewards = {
    TaskDifficulty.easy: 5,
    TaskDifficulty.medium: 15,
    TaskDifficulty.hard: 30,
  };

  static const Map<TaskDifficulty, int> damageValues = {
    TaskDifficulty.easy: 10,
    TaskDifficulty.medium: 25,
    TaskDifficulty.hard: 40,
  };

  Future<void> loadCharacter() async {
    final saved = await _isar.characters.get(1);
    if (saved != null) {
      _character = saved;
    } else {
      await _save();
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _isar.writeTxn(() async {
      await _isar.characters.put(_character);
    });
  }

  TaskReward completeTask(TaskDifficulty difficulty) {
    final levelBefore = _character.level;
    _character.currentXP += xpRewards[difficulty]!;
    _character.gold += goldRewards[difficulty]!;
    _checkLevelUp();
    _save();
    notifyListeners();
    return TaskReward(
      xpAwarded: xpRewards[difficulty]!,
      goldAwarded: goldRewards[difficulty]!,
      leveledUp: _character.level > levelBefore,
    );
  }

  void failTask(TaskDifficulty difficulty) {
    _character.currentHealth = max(0, _character.currentHealth - damageValues[difficulty]!);
    _checkDeath();
    _save();
    notifyListeners();
  }

  void _checkLevelUp() {
    while (_character.currentXP >= _character.xpToNextLevel) {
      _character.currentXP -= _character.xpToNextLevel;
      _character.level++;
      _character.maxHealth = 100 + (_character.level - 1) * 10;
      _character.currentHealth = _character.maxHealth;
      _character.maxMana = 50 + (_character.level - 1) * 5;
      _character.mana = _character.maxMana;
    }
  }

  /// Updates the character's skin and/or accent color. Equipment changes go
  /// through [setEquipment] (one slot at a time).
  Future<void> updateCustomization({
    String? skinId,
    int? accentColorValue,
  }) async {
    if (skinId != null) _character.selectedSkinId = skinId;
    if (accentColorValue != null) {
      _character.accentColorValue = accentColorValue;
    }
    await _save();
    notifyListeners();
  }

  Map<String, String> _decodeEquipped() {
    if (_character.equippedItemsJson.isEmpty) return {};
    final raw = jsonDecode(_character.equippedItemsJson);
    if (raw is! Map) return {};
    return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
  }

  Future<void> setEquipment(EquipmentSlot slot, String itemId) async {
    final map = _decodeEquipped();
    if (itemId.isEmpty) {
      map.remove(slot.name);
    } else {
      map[slot.name] = itemId;
    }
    _character.equippedItemsJson = jsonEncode(map);
    await _save();
    notifyListeners();
  }

  /// Returns the currently equipped item id for [slot], or `''` if nothing
  /// is equipped (the "None" option).
  String equippedIdFor(EquipmentSlot slot) {
    return _decodeEquipped()[slot.name] ?? '';
  }

  void _checkDeath() {
    if (_character.isDead) {
      _character.level = 1;
      _character.currentXP = 0;
      _character.maxHealth = 100;
      _character.currentHealth = _character.maxHealth;
      _character.maxMana = 50;
      _character.mana = _character.maxMana;
    }
  }
}
