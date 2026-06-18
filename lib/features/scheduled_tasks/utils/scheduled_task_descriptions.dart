import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';

const _weekdayNames = [
  '',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _weekdayShort = [
  '',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const _ordinalLabel = {
  MonthlyOrdinal.first: '1st',
  MonthlyOrdinal.second: '2nd',
  MonthlyOrdinal.third: '3rd',
  MonthlyOrdinal.fourth: '4th',
  MonthlyOrdinal.last: 'last',
};

String _dayOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String _joinHuman(List<String> items) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.first;
  if (items.length == 2) return '${items[0]} and ${items[1]}';
  return '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';
}

String recurrenceSummaryFrom({
  required RecurrenceType type,
  required int dailyInterval,
  required List<int> weeklyDays,
  required MonthlySubMode monthlySubMode,
  int? monthlyDayOfMonth,
  required MonthlyOrdinal monthlyOrdinal,
  int? monthlyWeekday,
}) {
  switch (type) {
    case RecurrenceType.daily:
      if (dailyInterval <= 1) return 'Task will repeat every day.';
      return 'Task will repeat every $dailyInterval days.';
    case RecurrenceType.weekly:
      if (weeklyDays.isEmpty) {
        return 'Select at least one day of the week.';
      }
      final sorted = [...weeklyDays]..sort();
      final names = sorted.map((d) => _weekdayNames[d]).toList();
      return 'Task will repeat every ${_joinHuman(names)}.';
    case RecurrenceType.monthly:
      if (monthlySubMode == MonthlySubMode.byDate) {
        final d = monthlyDayOfMonth ?? 1;
        final suffix = _dayOrdinalSuffix(d);
        if (d >= 29) {
          return 'Task will repeat on the $d$suffix (or last day of the month).';
        }
        return 'Task will repeat on the $d$suffix of every month.';
      } else {
        final wd = monthlyWeekday ?? DateTime.monday;
        final ord = _ordinalLabel[monthlyOrdinal]!;
        return 'Task will repeat on the $ord ${_weekdayNames[wd]} of every month.';
      }
  }
}

String notificationSummaryFrom({
  required ReminderMode mode,
  int? hour,
  int? minute,
  required int minutesBefore,
}) {
  if (mode == ReminderMode.none) return 'No notifications.';
  if (hour == null || minute == null) {
    return 'Choose a notification time.';
  }
  final hh = hour.toString().padLeft(2, '0');
  final mm = minute.toString().padLeft(2, '0');
  final time = '$hh:$mm';
  switch (mode) {
    case ReminderMode.atTime:
      return 'You will be notified at $time.';
    case ReminderMode.minutesBefore:
      return 'You will be notified $minutesBefore min before $time.';
    case ReminderMode.both:
      return 'You will be notified at $time and $minutesBefore min before.';
    case ReminderMode.none:
      return '';
  }
}

String recurrenceSummary(ScheduledTask t) => recurrenceSummaryFrom(
      type: t.recurrenceType,
      dailyInterval: t.dailyInterval,
      weeklyDays: t.weeklyDays,
      monthlySubMode: t.monthlySubMode,
      monthlyDayOfMonth: t.monthlyDayOfMonth,
      monthlyOrdinal: t.monthlyOrdinal,
      monthlyWeekday: t.monthlyWeekday,
    );

String notificationSummary(ScheduledTask t) => notificationSummaryFrom(
      mode: t.reminderMode,
      hour: t.notificationHour,
      minute: t.notificationMinute,
      minutesBefore: t.minutesBefore,
    );

/// Compact tile-badge string.
String recurrenceShortBadge(ScheduledTask t) {
  switch (t.recurrenceType) {
    case RecurrenceType.daily:
      return t.dailyInterval <= 1 ? 'Daily' : 'Every ${t.dailyInterval}d';
    case RecurrenceType.weekly:
      if (t.weeklyDays.isEmpty) return 'Weekly';
      if (t.weeklyDays.length == 7) return 'Daily';
      final sorted = [...t.weeklyDays]..sort();
      return sorted.map((d) => _weekdayShort[d]).join('/');
    case RecurrenceType.monthly:
      if (t.monthlySubMode == MonthlySubMode.byDate) {
        final d = t.monthlyDayOfMonth ?? 1;
        return 'Monthly $d${_dayOrdinalSuffix(d)}';
      } else {
        final wd = t.monthlyWeekday ?? DateTime.monday;
        final ord = _ordinalLabel[t.monthlyOrdinal]!;
        return '$ord ${_weekdayShort[wd]}';
      }
  }
}
