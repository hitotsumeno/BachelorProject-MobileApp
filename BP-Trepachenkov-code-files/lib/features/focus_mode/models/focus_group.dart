import 'package:isar/isar.dart';

part 'focus_group.g.dart';

@embedded
class FocusTimeWindow {
  int startHour = 0;
  int startMinute = 0;
  int endHour = 0;
  int endMinute = 0;

  @ignore
  int get startTotalMinutes => startHour * 60 + startMinute;

  @ignore
  int get endTotalMinutes => endHour * 60 + endMinute;

  @ignore
  bool get spansNextDay => endTotalMinutes <= startTotalMinutes;

  bool overlapsWith(FocusTimeWindow other) {
    final s1 = startTotalMinutes;
    final e1 = endTotalMinutes;
    final s2 = other.startTotalMinutes;
    final e2 = other.endTotalMinutes;

    // Simple case: neither spans midnight
    if (!spansNextDay && !other.spansNextDay) {
      return s1 < e2 && s2 < e1;
    }
    // If either spans midnight, check the two segments
    if (spansNextDay && !other.spansNextDay) {
      return s2 < e1 || s1 < e2;
    }
    if (!spansNextDay && other.spansNextDay) {
      return s1 < e2 || s2 < e1;
    }
    // Both span midnight — always overlap
    return true;
  }

  bool containsTime(int hour, int minute) {
    final t = hour * 60 + minute;
    if (!spansNextDay) {
      return t >= startTotalMinutes && t < endTotalMinutes;
    }
    // Spans midnight: active from start..23:59 and 00:00..end
    return t >= startTotalMinutes || t < endTotalMinutes;
  }
}

@Collection()
class FocusGroup {
  Id id = Isar.autoIncrement;

  String name = '';

  /// Package names of blocked apps
  List<String> appPackageNames = [];

  /// Display names (parallel to appPackageNames)
  List<String> appDisplayNames = [];

  /// Time windows for this group's schedule
  List<FocusTimeWindow> timeWindows = [];

  /// Active days: 1=Monday .. 7=Sunday (DateTime.weekday)
  List<int> activeDays = [];

  /// When true, group cannot be edited/deleted while active
  bool isStrict = false;

  /// Master on/off toggle
  bool isEnabled = true;

  /// Consecutive compliant days for this group
  int streak = 0;

  /// Last date (YYYY-MM-DD) the streak was evaluated, prevents double-increment
  String? lastStreakDate;

  /// Timed interval length in minutes (3–15), configurable per group
  int intervalLengthMinutes = 5;

  /// Number of free intervals allowed per day (0 = disabled)
  int intervalsPerDay = 0;

  /// How many intervals have been used today (resets at end-of-day)
  int intervalsUsedToday = 0;

  /// ISO 8601 datetime when the current active interval ends, null if none
  String? intervalEndsAt;

  /// Whether this group is currently in an active blocking window
  @ignore
  bool get isCurrentlyActive {
    if (!isEnabled) return false;
    final now = DateTime.now();
    if (!activeDays.contains(now.weekday)) return false;
    return timeWindows
        .any((w) => w.containsTime(now.hour, now.minute));
  }

  /// Whether editing/deletion is locked (strict + active)
  @ignore
  bool get isLocked => isStrict && isCurrentlyActive;

  /// How many intervals remain for today
  @ignore
  int get intervalsRemaining {
    if (intervalsPerDay <= 0) return 0;
    final remaining = intervalsPerDay - intervalsUsedToday;
    return remaining < 0 ? 0 : (remaining > intervalsPerDay ? intervalsPerDay : remaining);
  }
}
