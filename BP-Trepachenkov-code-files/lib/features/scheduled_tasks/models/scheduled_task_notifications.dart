import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';
import 'package:bp_flutter_app/core/services/notification_service.dart';

class ScheduledTaskNotifications {
  static final ScheduledTaskNotifications _instance =
      ScheduledTaskNotifications._internal();
  factory ScheduledTaskNotifications() => _instance;
  ScheduledTaskNotifications._internal();

  static const int _idStride = 1000;
  static const int _beforeIdOffset = 500;
  static const int _horizon = 30;

  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationService.channelId,
      NotificationService.channelName,
      channelDescription: NotificationService.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> schedule(ScheduledTask task) async {
    await cancel(task.id);

    if (task.reminderMode == ReminderMode.none) return;
    if (task.notificationHour == null || task.notificationMinute == null) {
      return;
    }
    if (task.isDone) return;

    final now = DateTime.now();
    final upcoming = task.upcomingActiveDates(now, limit: _horizon);

    final baseId = task.id * _idStride;

    for (var i = 0; i < upcoming.length; i++) {
      final day = upcoming[i];
      final atTime = DateTime(
        day.year,
        day.month,
        day.day,
        task.notificationHour!,
        task.notificationMinute!,
      );
      if (atTime.isBefore(now)) continue;

      final tzAt = tz.TZDateTime.from(atTime, tz.local);

      if (task.reminderMode == ReminderMode.atTime ||
          task.reminderMode == ReminderMode.both) {
        await NotificationService().scheduleNotification(
          id: baseId + i,
          title: task.text,
          body: task.note ?? 'Your scheduled task is due now',
          scheduledDate: tzAt,
          details: _notificationDetails,
        );
      }

      if (task.reminderMode == ReminderMode.minutesBefore ||
          task.reminderMode == ReminderMode.both) {
        final beforeDate =
            atTime.subtract(Duration(minutes: task.minutesBefore));
        if (beforeDate.isBefore(now)) continue;
        final tzBefore = tz.TZDateTime.from(beforeDate, tz.local);
        await NotificationService().scheduleNotification(
          id: baseId + _beforeIdOffset + i,
          title: '${task.text} — coming up',
          body: 'Due in ${task.minutesBefore} minutes',
          scheduledDate: tzBefore,
          details: _notificationDetails,
        );
      }
    }
  }

  Future<void> cancel(int taskId) async {
    final baseId = taskId * _idStride;
    for (var i = 0; i < _horizon; i++) {
      await NotificationService().cancelNotification(baseId + i);
      await NotificationService()
          .cancelNotification(baseId + _beforeIdOffset + i);
    }
  }
}
