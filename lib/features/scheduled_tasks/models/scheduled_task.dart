import 'package:isar/isar.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';

part 'scheduled_task.g.dart';

enum RecurrenceType { daily, weekly, monthly }

enum MonthlySubMode { byDate, byOrdinalWeekday }

enum MonthlyOrdinal { first, second, third, fourth, last }

enum ReminderMode { none, atTime, minutesBefore, both }

@Collection()
class ScheduledTask {
  Id id = Isar.autoIncrement;
  late String text;
  String? note;

  // Anchor date (used for Daily-every-N interval math) and day of creation.
  DateTime? scheduledDate;

  @enumerated
  TaskDifficulty difficulty = TaskDifficulty.easy;

  // --- Recurrence ---
  @enumerated
  RecurrenceType recurrenceType = RecurrenceType.daily;

  int dailyInterval = 1;

  List<int> weeklyDays = []; // 1=Mon..7=Sun

  @enumerated
  MonthlySubMode monthlySubMode = MonthlySubMode.byDate;

  int? monthlyDayOfMonth;

  @enumerated
  MonthlyOrdinal monthlyOrdinal = MonthlyOrdinal.first;

  int? monthlyWeekday; // 1..7 for byOrdinalWeekday

  // --- Notification ---
  @enumerated
  ReminderMode reminderMode = ReminderMode.atTime;

  int? notificationHour;
  int? notificationMinute;

  int minutesBefore = 15;

  // --- Completion / streak ---
  bool isDone = false;

  int streak = 0;
  DateTime? lastStreakDate;
  DateTime? lastCompletedDate;

  bool isActiveOn(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    switch (recurrenceType) {
      case RecurrenceType.daily:
        final anchor = _anchorDate();
        final diff = d.difference(anchor).inDays;
        if (diff < 0) return false;
        final n = dailyInterval < 1 ? 1 : dailyInterval;
        return diff % n == 0;
      case RecurrenceType.weekly:
        return weeklyDays.contains(d.weekday);
      case RecurrenceType.monthly:
        switch (monthlySubMode) {
          case MonthlySubMode.byDate:
            final target = monthlyDayOfMonth ?? 1;
            final lastDay = DateTime(d.year, d.month + 1, 0).day;
            final effective = target > lastDay ? lastDay : target;
            return d.day == effective;
          case MonthlySubMode.byOrdinalWeekday:
            final wd = monthlyWeekday ?? DateTime.monday;
            final match =
                nthWeekdayOfMonth(d.year, d.month, wd, monthlyOrdinal);
            return match != null && match.day == d.day;
        }
    }
  }

  DateTime? previousActiveDay(DateTime today) {
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 1));
    for (var i = 0; i < 400; i++) {
      final d = start.subtract(Duration(days: i));
      if (isActiveOn(d)) return DateTime(d.year, d.month, d.day);
    }
    return null;
  }

  /// Iterates upcoming active dates from [from] (inclusive) up to [limit] entries,
  /// scanning at most [scanLimitDays] calendar days.
  List<DateTime> upcomingActiveDates(
    DateTime from, {
    int limit = 30,
    int scanLimitDays = 400,
  }) {
    final start = DateTime(from.year, from.month, from.day);
    final out = <DateTime>[];
    for (var i = 0; i < scanLimitDays && out.length < limit; i++) {
      final d = start.add(Duration(days: i));
      if (isActiveOn(d)) out.add(d);
    }
    return out;
  }

  DateTime _anchorDate() {
    final s = scheduledDate ?? DateTime.now();
    return DateTime(s.year, s.month, s.day);
  }
}

DateTime? nthWeekdayOfMonth(
    int year, int month, int weekday, MonthlyOrdinal ord) {
  final lastDay = DateTime(year, month + 1, 0).day;
  if (ord == MonthlyOrdinal.last) {
    for (var day = lastDay; day >= lastDay - 6; day--) {
      final d = DateTime(year, month, day);
      if (d.weekday == weekday) return d;
    }
    return null;
  }
  final n = const {
    MonthlyOrdinal.first: 1,
    MonthlyOrdinal.second: 2,
    MonthlyOrdinal.third: 3,
    MonthlyOrdinal.fourth: 4,
  }[ord]!;
  var count = 0;
  for (var day = 1; day <= lastDay; day++) {
    final d = DateTime(year, month, day);
    if (d.weekday == weekday) {
      count++;
      if (count == n) return d;
    }
  }
  return null;
}
