import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'package:bp_flutter_app/core/services/isar_service.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task_notifications.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';
import 'package:bp_flutter_app/features/tasks/models/task_reward.dart';

enum ScheduledEditMode { none, createTask, editTask }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class ScheduledTaskRepository extends ChangeNotifier {
  final Isar _isar = IsarService.isar;
  final CharacterNotifier _characterNotifier;

  ScheduledTaskRepository(this._characterNotifier);

  final List<ScheduledTask> currentTasks = [];
  final List<ScheduledTask> archivedTasks = [];

  // --- Overlay State ---
  ScheduledEditMode _mode = ScheduledEditMode.none;
  ScheduledEditMode get mode => _mode;

  ScheduledTask? _editingTask;
  ScheduledTask? get editingTask => _editingTask;

  bool get isOverlayOpen => _mode != ScheduledEditMode.none;

  DateTime? _overlayScheduledDate;
  DateTime? get overlayScheduledDate => _overlayScheduledDate;

  TaskDifficulty _overlayDifficulty = TaskDifficulty.easy;
  TaskDifficulty get overlayDifficulty => _overlayDifficulty;

  // Recurrence overlay fields
  RecurrenceType _overlayRecurrenceType = RecurrenceType.daily;
  RecurrenceType get overlayRecurrenceType => _overlayRecurrenceType;

  int _overlayDailyInterval = 1;
  int get overlayDailyInterval => _overlayDailyInterval;

  List<int> _overlayWeeklyDays = [];
  List<int> get overlayWeeklyDays => List.unmodifiable(_overlayWeeklyDays);

  MonthlySubMode _overlayMonthlySubMode = MonthlySubMode.byDate;
  MonthlySubMode get overlayMonthlySubMode => _overlayMonthlySubMode;

  int? _overlayMonthlyDayOfMonth;
  int? get overlayMonthlyDayOfMonth => _overlayMonthlyDayOfMonth;

  MonthlyOrdinal _overlayMonthlyOrdinal = MonthlyOrdinal.first;
  MonthlyOrdinal get overlayMonthlyOrdinal => _overlayMonthlyOrdinal;

  int? _overlayMonthlyWeekday;
  int? get overlayMonthlyWeekday => _overlayMonthlyWeekday;

  // Reminder overlay fields
  ReminderMode _overlayReminderMode = ReminderMode.atTime;
  ReminderMode get overlayReminderMode => _overlayReminderMode;

  int? _overlayNotificationHour;
  int? get overlayNotificationHour => _overlayNotificationHour;

  int? _overlayNotificationMinute;
  int? get overlayNotificationMinute => _overlayNotificationMinute;

  int _overlayMinutesBefore = 15;
  int get overlayMinutesBefore => _overlayMinutesBefore;

  // Last save-time validation error (transient), surfaced by overlay if non-null.
  String? _saveError;
  String? get saveError => _saveError;

  /// Called from main.dart at startup. Runs daily reset + streak catch-up,
  /// then refreshes the in-memory list and reschedules all notifications.
  Future<void> init() async {
    await _runDailyResetAndCatchUp();
    await fetchTasks();
    await rescheduleAllNotifications();
  }

  Future<void> _runDailyResetAndCatchUp() async {
    final today = _dateOnly(DateTime.now());
    await _isar.writeTxn(() async {
      final all = await _isar.scheduledTasks.where().findAll();
      for (final t in all) {
        var dirty = false;

        // Daily reset: if last completion was before today, unmark so the
        // recurring task is fresh for the new day.
        if (t.isDone &&
            t.lastCompletedDate != null &&
            _dateOnly(t.lastCompletedDate!).isBefore(today)) {
          t.isDone = false;
          dirty = true;
        }

        // Streak catch-up: if today is on-day and the most recent previous
        // on-day was missed (last streak advance is older than that), reset.
        if (t.streak > 0 && t.lastStreakDate != null && t.isActiveOn(today)) {
          final prev = t.previousActiveDay(today);
          if (prev != null &&
              _dateOnly(t.lastStreakDate!).isBefore(_dateOnly(prev))) {
            t.streak = 0;
            t.lastStreakDate = null;
            dirty = true;
          }
        }

        if (dirty) await _isar.scheduledTasks.put(t);
      }
    });
  }

  Future<void> rescheduleAllNotifications() async {
    for (final t in currentTasks) {
      try {
        await ScheduledTaskNotifications().schedule(t);
      } catch (e) {
        debugPrint('Reschedule failed for task ${t.id}: $e');
      }
    }
  }

  Future<void> fetchTasks() async {
    final all = await _isar.scheduledTasks.where().findAll();
    currentTasks
      ..clear()
      ..addAll(all.where((t) => !t.isDone));
    archivedTasks.clear(); // all tasks are recurring; no archive list
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await _isar.writeTxn(() => _isar.scheduledTasks.delete(id));
    await ScheduledTaskNotifications().cancel(id);
    await fetchTasks();
  }

  Future<void> deleteEditingTask() async {
    if (_editingTask == null) return;
    final id = _editingTask!.id;
    await _isar.writeTxn(() async {
      await _isar.scheduledTasks.delete(id);
    });
    await ScheduledTaskNotifications().cancel(id);
    closeOverlay();
    await fetchTasks();
  }

  Future<TaskReward?> toggleTask(Id id) async {
    TaskReward? reward;
    final today = _dateOnly(DateTime.now());

    await _isar.writeTxn(() async {
      final task = await _isar.scheduledTasks.get(id);
      if (task == null) return;

      final wasCompleted = task.isDone;
      task.isDone = !task.isDone;

      if (!wasCompleted) {
        // Check → completion
        task.lastCompletedDate = today;
        reward = _characterNotifier.completeTask(task.difficulty);

        if (task.isActiveOn(today)) {
          final prev = task.previousActiveDay(today);
          if (task.lastStreakDate != null &&
              prev != null &&
              _dateOnly(task.lastStreakDate!) == _dateOnly(prev)) {
            task.streak += 1;
          } else {
            task.streak = 1;
          }
          task.lastStreakDate = today;
        }
      } else {
        // Uncheck → reverse XP/gold
        _characterNotifier.failTask(task.difficulty);

        // Reverse same-day streak increment, if any.
        if (task.lastStreakDate != null &&
            _dateOnly(task.lastStreakDate!) == today) {
          task.streak = (task.streak - 1).clamp(0, 1 << 30);
          task.lastStreakDate =
              task.streak == 0 ? null : task.previousActiveDay(today);
        }

        if (task.lastCompletedDate != null &&
            _dateOnly(task.lastCompletedDate!) == today) {
          task.lastCompletedDate = null;
        }
      }

      await _isar.scheduledTasks.put(task);
    });

    // Update notifications: cancel when done, reschedule when reopened.
    final updated = await _isar.scheduledTasks.get(id);
    if (updated != null) {
      try {
        if (updated.isDone) {
          await ScheduledTaskNotifications().cancel(updated.id);
        } else {
          await ScheduledTaskNotifications().schedule(updated);
        }
      } catch (e) {
        debugPrint('Notification update failed: $e');
      }
    }

    await fetchTasks();
    return reward;
  }

  Future<void> restoreTask(Id id) async {
    await _isar.writeTxn(() async {
      final task = await _isar.scheduledTasks.get(id);
      if (task != null) {
        task.isDone = false;
        await _isar.scheduledTasks.put(task);
      }
    });
    await fetchTasks();
  }

  // --- Overlay controls ---
  void openCreate() {
    _editingTask = null;
    _overlayScheduledDate = DateTime.now();
    _overlayDifficulty = TaskDifficulty.easy;
    _overlayRecurrenceType = RecurrenceType.daily;
    _overlayDailyInterval = 1;
    _overlayWeeklyDays = [DateTime.now().weekday];
    _overlayMonthlySubMode = MonthlySubMode.byDate;
    _overlayMonthlyDayOfMonth = DateTime.now().day;
    _overlayMonthlyOrdinal = MonthlyOrdinal.first;
    _overlayMonthlyWeekday = DateTime.now().weekday;
    _overlayReminderMode = ReminderMode.atTime;
    _overlayNotificationHour = null;
    _overlayNotificationMinute = null;
    _overlayMinutesBefore = 15;
    _saveError = null;
    _mode = ScheduledEditMode.createTask;
    notifyListeners();
  }

  void openEdit(ScheduledTask task) {
    _editingTask = task;
    _overlayScheduledDate = task.scheduledDate;
    _overlayDifficulty = task.difficulty;
    _overlayRecurrenceType = task.recurrenceType;
    _overlayDailyInterval = task.dailyInterval < 1 ? 1 : task.dailyInterval;
    _overlayWeeklyDays = [...task.weeklyDays];
    _overlayMonthlySubMode = task.monthlySubMode;
    _overlayMonthlyDayOfMonth =
        task.monthlyDayOfMonth ?? task.scheduledDate?.day ?? 1;
    _overlayMonthlyOrdinal = task.monthlyOrdinal;
    _overlayMonthlyWeekday =
        task.monthlyWeekday ?? task.scheduledDate?.weekday ?? DateTime.monday;
    _overlayReminderMode = task.reminderMode;
    _overlayNotificationHour = task.notificationHour;
    _overlayNotificationMinute = task.notificationMinute;
    _overlayMinutesBefore = task.minutesBefore;
    _saveError = null;
    _mode = ScheduledEditMode.editTask;
    notifyListeners();
  }

  void closeOverlay() {
    _editingTask = null;
    _mode = ScheduledEditMode.none;
    _saveError = null;
    notifyListeners();
  }

  void setOverlayScheduledDate(DateTime? date) {
    _overlayScheduledDate = date;
    notifyListeners();
  }

  void setOverlayDifficulty(TaskDifficulty difficulty) {
    _overlayDifficulty = difficulty;
    notifyListeners();
  }

  void setOverlayRecurrenceType(RecurrenceType type) {
    _overlayRecurrenceType = type;
    notifyListeners();
  }

  void setOverlayDailyInterval(int interval) {
    _overlayDailyInterval = interval.clamp(1, 30);
    notifyListeners();
  }

  void toggleOverlayWeeklyDay(int weekday) {
    final list = [..._overlayWeeklyDays];
    if (list.contains(weekday)) {
      list.remove(weekday);
    } else {
      list.add(weekday);
    }
    _overlayWeeklyDays = list;
    notifyListeners();
  }

  void setOverlayWeeklyDays(List<int> days) {
    _overlayWeeklyDays = [...days];
    notifyListeners();
  }

  void setOverlayMonthlySubMode(MonthlySubMode sub) {
    _overlayMonthlySubMode = sub;
    notifyListeners();
  }

  void setOverlayMonthlyDayOfMonth(int day) {
    _overlayMonthlyDayOfMonth = day.clamp(1, 31);
    notifyListeners();
  }

  void setOverlayMonthlyOrdinal(MonthlyOrdinal ord) {
    _overlayMonthlyOrdinal = ord;
    notifyListeners();
  }

  void setOverlayMonthlyWeekday(int weekday) {
    _overlayMonthlyWeekday = weekday;
    notifyListeners();
  }

  void setOverlayReminderMode(ReminderMode mode) {
    _overlayReminderMode = mode;
    notifyListeners();
  }

  void setOverlayNotificationTime(int? hour, int? minute) {
    _overlayNotificationHour = hour;
    _overlayNotificationMinute = minute;
    notifyListeners();
  }

  void setOverlayMinutesBefore(int minutes) {
    _overlayMinutesBefore = minutes < 1 ? 1 : minutes;
    notifyListeners();
  }

  /// Returns a non-null error message on validation failure, null on success.
  Future<String?> saveOverlay(String title, String? note) async {
    // Validation
    if (title.trim().isEmpty) {
      _saveError = 'Title is required';
      notifyListeners();
      return _saveError;
    }
    if (_overlayRecurrenceType == RecurrenceType.weekly &&
        _overlayWeeklyDays.isEmpty) {
      _saveError = 'Select at least one day of the week';
      notifyListeners();
      return _saveError;
    }
    if (_overlayReminderMode != ReminderMode.none &&
        (_overlayNotificationHour == null ||
            _overlayNotificationMinute == null)) {
      _saveError = 'Choose a notification time';
      notifyListeners();
      return _saveError;
    }

    _saveError = null;

    ScheduledTask? savedTask;

    void applyFields(ScheduledTask t) {
      t.text = title;
      t.note = note;
      t.scheduledDate = _overlayScheduledDate;
      t.difficulty = _overlayDifficulty;
      t.recurrenceType = _overlayRecurrenceType;
      t.dailyInterval = _overlayDailyInterval;
      t.weeklyDays = [..._overlayWeeklyDays]..sort();
      t.monthlySubMode = _overlayMonthlySubMode;
      t.monthlyDayOfMonth = _overlayMonthlyDayOfMonth;
      t.monthlyOrdinal = _overlayMonthlyOrdinal;
      t.monthlyWeekday = _overlayMonthlyWeekday;
      t.reminderMode = _overlayReminderMode;
      t.notificationHour = _overlayNotificationHour;
      t.notificationMinute = _overlayNotificationMinute;
      t.minutesBefore = _overlayMinutesBefore;
    }

    if (_mode == ScheduledEditMode.createTask) {
      final newTask = ScheduledTask();
      applyFields(newTask);
      await _isar.writeTxn(() async {
        await _isar.scheduledTasks.put(newTask);
      });
      savedTask = newTask;
    }

    if (_mode == ScheduledEditMode.editTask && _editingTask != null) {
      await _isar.writeTxn(() async {
        final task = _editingTask!;
        applyFields(task);
        await _isar.scheduledTasks.put(task);
      });
      savedTask = _editingTask;
    }

    if (savedTask != null) {
      try {
        await ScheduledTaskNotifications().schedule(savedTask);
      } catch (e) {
        debugPrint('Notification scheduling failed: $e');
      }
    }

    closeOverlay();
    await fetchTasks();
    return null;
  }
}
