import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:bp_flutter_app/core/services/isar_service.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';
import 'package:bp_flutter_app/features/focus_mode/models/focus_group.dart';
import 'package:bp_flutter_app/features/focus_mode/models/daily_compliance.dart';
import 'package:bp_flutter_app/features/focus_mode/services/focus_mode_service.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';

enum FocusEditMode { none, createGroup, editGroup, viewGroup }

class FocusModeProvider extends ChangeNotifier {
  final Isar _isar = IsarService.isar;
  final CharacterNotifier _characterNotifier;

  List<FocusGroup> _groups = [];
  List<FocusGroup> get groups => _groups;

  bool _permissionsGranted = false;
  bool get permissionsGranted => _permissionsGranted;

  /// Cached app icons keyed by package name, loaded once during init.
  Map<String, Uint8List> _appIconCache = {};
  Map<String, Uint8List> get appIconCache => _appIconCache;

  // ── Overlay state ──

  FocusEditMode _mode = FocusEditMode.none;
  FocusEditMode get mode => _mode;

  FocusGroup? _editingGroup;
  FocusGroup? get editingGroup => _editingGroup;

  void openCreateOverlay() {
    _editingGroup = FocusGroup()..activeDays = [1, 2, 3, 4, 5];
    _mode = FocusEditMode.createGroup;
    notifyListeners();
  }

  FocusGroup _deepCopyGroup(FocusGroup group) {
    return FocusGroup()
      ..id = group.id
      ..name = group.name
      ..appPackageNames = List.from(group.appPackageNames)
      ..appDisplayNames = List.from(group.appDisplayNames)
      ..timeWindows = group.timeWindows
          .map((w) => FocusTimeWindow()
            ..startHour = w.startHour
            ..startMinute = w.startMinute
            ..endHour = w.endHour
            ..endMinute = w.endMinute)
          .toList()
      ..activeDays = List.from(group.activeDays)
      ..isStrict = group.isStrict
      ..isEnabled = group.isEnabled
      ..streak = group.streak
      ..lastStreakDate = group.lastStreakDate
      ..intervalLengthMinutes = group.intervalLengthMinutes
      ..intervalsPerDay = group.intervalsPerDay
      ..intervalsUsedToday = group.intervalsUsedToday
      ..intervalEndsAt = group.intervalEndsAt;
  }

  void openEditOverlay(FocusGroup group) {
    _editingGroup = _deepCopyGroup(group);
    _mode = FocusEditMode.editGroup;
    notifyListeners();
  }

  void openViewOverlay(FocusGroup group) {
    _editingGroup = _deepCopyGroup(group);
    _mode = FocusEditMode.viewGroup;
    notifyListeners();
  }

  void closeOverlay() {
    _mode = FocusEditMode.none;
    _editingGroup = null;
    notifyListeners();
  }

  void updateEditingGroup(FocusGroup updated) {
    _editingGroup = updated;
    notifyListeners();
  }

  Future<void> saveOverlay() async {
    if (_editingGroup == null) return;
    // If strict was toggled on while an interval is active, end it immediately.
    if (_editingGroup!.isStrict && _editingGroup!.intervalEndsAt != null) {
      _editingGroup!.intervalEndsAt = null;
    }
    await saveGroup(_editingGroup!);
    closeOverlay();
  }

  Future<void> deleteEditingGroup() async {
    if (_editingGroup == null) return;
    await deleteGroup(_editingGroup!.id);
    closeOverlay();
  }

  FocusModeProvider(this._characterNotifier);

  // ── Init ──

  Future<void> init() async {
    await _loadGroups();
    await _loadAppIcons();
    await checkPermissions();
    await _consumeNativeBypasses();
    await _consumeNativeIntervals();
    await _clearExpiredIntervals();
    await _checkPendingReward();
    await _syncBlockingService();
    await FocusModeService.scheduleEndOfDayAlarm();
  }

  /// Pick up any bypass events recorded by the native overlay while
  /// Flutter was not running (or in background).
  Future<void> _consumeNativeBypasses() async {
    try {
      final data = await FocusModeService.consumeNativeBypasses();
      final count = data['count'] as int? ?? 0;
      if (count > 0) {
        // Record each bypass into Isar compliance
        for (int i = 0; i < count; i++) {
          await recordBypass();
        }
      }
    } catch (_) {
      // Platform channel may fail on non-Android — ignore
    }
  }

  /// Load app icons for all packages referenced by groups.
  Future<void> _loadAppIcons() async {
    try {
      final neededPackages = <String>{};
      for (final g in _groups) {
        neededPackages.addAll(g.appPackageNames);
      }
      if (neededPackages.isEmpty) return;

      final rawApps = await FocusModeService.getInstalledApps();
      final cache = <String, Uint8List>{};
      for (final app in rawApps) {
        final pkg = app['packageName'] as String;
        final icon = app['icon'] as Uint8List?;
        if (icon != null && neededPackages.contains(pkg)) {
          cache[pkg] = icon;
        }
      }
      _appIconCache = cache;
      notifyListeners();
    } catch (_) {
      // Platform channel may fail on non-Android — ignore
    }
  }

  /// Pick up interval-usage events recorded by the native overlay.
  Future<void> _consumeNativeIntervals() async {
    try {
      final data = await FocusModeService.consumeNativeIntervals();
      final used = data['intervalsUsed'] as int? ?? 0;
      final endTime = data['intervalEndTime'] as int?;
      final packages = data['intervalPackages'] as String?;

      if (used <= 0 && endTime == null) return;

      // Find which group these interval packages belong to
      FocusGroup? targetGroup;
      if (packages != null && packages.isNotEmpty) {
        final pkgList = packages.split(',');
        targetGroup = _groups.where((g) =>
            g.appPackageNames.any((p) => pkgList.contains(p))).firstOrNull;
      }

      if (targetGroup != null && used > 0) {
        targetGroup.intervalsUsedToday += used;
        // If there's an active interval end time still in the future, record it
        if (endTime != null) {
          final endDt = DateTime.fromMillisecondsSinceEpoch(endTime);
          if (endDt.isAfter(DateTime.now())) {
            targetGroup.intervalEndsAt = endDt.toIso8601String();
          }
        }
        await _isar.writeTxn(() async {
          await _isar.focusGroups.put(targetGroup!);
        });
        await _loadGroups();
      }
    } catch (_) {
      // Platform channel may fail on non-Android — ignore
    }
  }

  /// Clear any expired interval end times on groups.
  Future<void> _clearExpiredIntervals() async {
    bool changed = false;
    final now = DateTime.now();
    for (final group in _groups) {
      if (group.intervalEndsAt != null) {
        final endDt = DateTime.tryParse(group.intervalEndsAt!);
        if (endDt == null || endDt.isBefore(now)) {
          group.intervalEndsAt = null;
          changed = true;
        }
      }
    }
    if (changed) {
      await _isar.writeTxn(() async {
        await _isar.focusGroups.putAll(_groups);
      });
    }
  }

  Future<void> _loadGroups() async {
    _groups = await _isar.focusGroups.where().findAll();
    notifyListeners();
  }

  // ── Permissions ──

  Future<void> checkPermissions() async {
    final hasUsage = await FocusModeService.hasUsageStatsPermission();
    final hasOverlay = await FocusModeService.hasOverlayPermission();
    _permissionsGranted = hasUsage && hasOverlay;
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    final hasUsage = await FocusModeService.hasUsageStatsPermission();
    if (!hasUsage) {
      await FocusModeService.requestUsageStatsPermission();
    }
    final hasOverlay = await FocusModeService.hasOverlayPermission();
    if (!hasOverlay) {
      await FocusModeService.requestOverlayPermission();
    }
    await checkPermissions();
  }

  // ── CRUD ──

  Future<void> saveGroup(FocusGroup group) async {
    await _isar.writeTxn(() async {
      await _isar.focusGroups.put(group);
    });
    await _loadGroups();
    await _syncBlockingService();
  }

  Future<void> deleteGroup(int groupId) async {
    final group = _groups.where((g) => g.id == groupId).firstOrNull;
    if (group != null && group.isLocked) return; // strict + active → blocked
    await _isar.writeTxn(() async {
      await _isar.focusGroups.delete(groupId);
    });
    await _loadGroups();
    await _syncBlockingService();
  }

  Future<void> toggleGroupEnabled(int groupId) async {
    final group = _groups.where((g) => g.id == groupId).firstOrNull;
    if (group == null) return;
    if (group.isLocked) return; // strict + active → can't toggle off
    group.isEnabled = !group.isEnabled;
    await saveGroup(group);
  }

  // ── Strict mode lift ──

  /// Lift strict mode on a group, resetting its streak to 0.
  /// This is the only way to exit strict mode while a window is active.
  Future<void> liftStrictMode(int groupId) async {
    final group = _groups.where((g) => g.id == groupId).firstOrNull;
    if (group == null) return;
    group.isStrict = false;
    group.streak = 0;
    await saveGroup(group);
  }

  // ── Active window evaluation ──

  /// Returns all package names that should be blocked right now.
  List<String> get currentlyBlockedPackages {
    final blocked = <String>{};
    for (final group in _groups) {
      if (group.isCurrentlyActive) {
        blocked.addAll(group.appPackageNames);
      }
    }
    return blocked.toList();
  }

  /// Whether a specific package is blocked right now.
  bool isPackageBlocked(String packageName) {
    return _groups.any(
      (g) => g.isCurrentlyActive && g.appPackageNames.contains(packageName),
    );
  }

  /// Whether the blocking group for a package is strict (no bypass allowed).
  bool isPackageStrictBlocked(String packageName) {
    return _groups.any(
      (g) =>
          g.isCurrentlyActive &&
          g.isStrict &&
          g.appPackageNames.contains(packageName),
    );
  }

  // ── Blocking service sync ──

  Future<void> _syncBlockingService() async {
    final blocked = currentlyBlockedPackages;
    if (blocked.isEmpty) {
      final running = await FocusModeService.isBlockingServiceRunning();
      if (running) await FocusModeService.stopBlockingService();
      return;
    }

    final scheduleData = _buildScheduleJson();
    final running = await FocusModeService.isBlockingServiceRunning();
    if (running) {
      await FocusModeService.updateBlockedApps(blocked);
      await FocusModeService.updateScheduleJson(scheduleData);
    } else {
      await FocusModeService.startBlockingService(
        blockedPackages: blocked,
        scheduleJson: scheduleData,
      );
    }
  }

  String _buildScheduleJson() {
    final data = _groups
        .where((g) => g.isEnabled)
        .map((g) => {
              'id': g.id,
              'packages': g.appPackageNames,
              'isStrict': g.isStrict,
              'activeDays': g.activeDays,
              'windows': g.timeWindows
                  .map((w) => {
                        'sh': w.startHour,
                        'sm': w.startMinute,
                        'eh': w.endHour,
                        'em': w.endMinute,
                      })
                  .toList(),
              'intervalMinutes': g.intervalLengthMinutes,
              'intervalsPerDay': g.intervalsPerDay,
              'intervalsRemaining': g.intervalsRemaining,
              'streak': g.streak,
            })
        .toList();
    return jsonEncode(data);
  }

  // ── Daily compliance ──

  /// Track which group IDs had a bypass or violation today (in-memory).
  final Set<int> _violatedGroupIds = {};

  Future<void> recordBypass({int? groupId}) async {
    if (groupId != null) _violatedGroupIds.add(groupId);

    final key = DailyCompliance.todayKey();
    var record = await _isar.dailyCompliances
        .where()
        .dateKeyEqualTo(key)
        .findFirst();

    record ??= DailyCompliance()..dateKey = key;
    record.bypassCount++;
    record.compliant = false;

    await _isar.writeTxn(() async {
      await _isar.dailyCompliances.put(record!);
    });
  }

  /// Record a strict-mode violation for a group (e.g. blocked app detected).
  void recordGroupViolation(int groupId) {
    _violatedGroupIds.add(groupId);
  }

  /// Called at end of day (from background or on app launch).
  /// Checks compliance and fires reward hook if earned.
  Future<void> evaluateEndOfDay({DateTime? forDate}) async {
    final date = forDate ?? DateTime.now();
    final key = DailyCompliance.keyForDate(date);

    var record = await _isar.dailyCompliances
        .where()
        .dateKeyEqualTo(key)
        .findFirst();

    // No record means no bypasses happened — compliant by default
    record ??= DailyCompliance()
      ..dateKey = key
      ..compliant = true;

    if (record.rewardGranted) return; // already rewarded

    if (record.compliant) {
      // Fire reward hook — uses medium difficulty as focus reward
      _characterNotifier.completeTask(TaskDifficulty.medium);
    }

    record.rewardGranted = true;
    await _isar.writeTxn(() async {
      await _isar.dailyCompliances.put(record!);
    });

    // ── Per-group streak evaluation ──
    await _evaluateGroupStreaks(key);

    // ── Reset daily interval quotas ──
    await _resetDailyIntervals();

    _violatedGroupIds.clear();
    notifyListeners();
  }

  Future<void> _evaluateGroupStreaks(String dateKey) async {
    bool changed = false;
    for (final group in _groups) {
      // Already evaluated this group for this date — skip (idempotent)
      if (group.lastStreakDate == dateKey) continue;

      // Check if the group had any active windows today
      // (we approximate: if the group has today's weekday in activeDays)
      final date = _parseDate(dateKey);
      if (date == null) continue;
      if (!group.activeDays.contains(date.weekday)) continue; // neutral day

      if (_violatedGroupIds.contains(group.id)) {
        group.streak = 0;
      } else {
        group.streak++;
      }
      group.lastStreakDate = dateKey;
      changed = true;
    }
    if (changed) {
      await _isar.writeTxn(() async {
        await _isar.focusGroups.putAll(_groups);
      });
    }
  }

  static DateTime? _parseDate(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;
    return DateTime.tryParse(key);
  }

  /// On app launch: check if yesterday's reward was missed.
  Future<void> _checkPendingReward() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final key = DailyCompliance.keyForDate(yesterday);
    final record = await _isar.dailyCompliances
        .where()
        .dateKeyEqualTo(key)
        .findFirst();

    if (record == null || !record.rewardGranted) {
      await evaluateEndOfDay(forDate: yesterday);
    }
  }

  /// Reset intervalsUsedToday for all groups at end-of-day.
  Future<void> _resetDailyIntervals() async {
    bool changed = false;
    for (final group in _groups) {
      if (group.intervalsUsedToday > 0) {
        group.intervalsUsedToday = 0;
        changed = true;
      }
    }
    if (changed) {
      await _isar.writeTxn(() async {
        await _isar.focusGroups.putAll(_groups);
      });
    }
  }

  // ── Validation helpers ──

  /// Check for overlapping windows within a single group's schedule.
  /// Returns null if valid, or an error message if overlaps found.
  static String? validateTimeWindows(List<FocusTimeWindow> windows) {
    for (int i = 0; i < windows.length; i++) {
      for (int j = i + 1; j < windows.length; j++) {
        if (windows[i].overlapsWith(windows[j])) {
          return 'Time windows ${i + 1} and ${j + 1} overlap. '
              'Please adjust them so they don\'t conflict.';
        }
      }
    }
    return null;
  }

  /// Whether a group can be saved (has name, apps, schedule).
  static bool canSaveGroup(FocusGroup group) {
    return group.name.trim().isNotEmpty &&
        group.appPackageNames.isNotEmpty &&
        group.timeWindows.isNotEmpty &&
        group.activeDays.isNotEmpty;
  }
}
