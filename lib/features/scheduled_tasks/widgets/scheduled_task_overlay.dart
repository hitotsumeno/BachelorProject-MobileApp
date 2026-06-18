import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/utils/scheduled_task_descriptions.dart';

import 'package:bp_flutter_app/features/tasks/widgets/difficulty_picker.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/recurrence_picker.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/reminder_picker.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/scheduled_date_time_picker.dart';

class ScheduledTaskOverlay extends StatefulWidget {
  const ScheduledTaskOverlay({super.key});

  @override
  State<ScheduledTaskOverlay> createState() => _ScheduledTaskOverlayState();
}

class _ScheduledTaskOverlayState extends State<ScheduledTaskOverlay> {
  final TextEditingController titleCntrl = TextEditingController();
  final TextEditingController noteCntrl = TextEditingController();

  ScheduledEditMode? _lastMode;

  @override
  void dispose() {
    titleCntrl.dispose();
    noteCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduledTaskRepository>(
      builder: (context, repo, _) {
        final mode = repo.mode;
        final task = repo.editingTask;

        if (_lastMode != mode) {
          _lastMode = mode;
          if (mode == ScheduledEditMode.editTask && task != null) {
            titleCntrl.text = task.text;
            noteCntrl.text = task.note ?? '';
          }
          if (mode == ScheduledEditMode.createTask) {
            titleCntrl.text = '';
            noteCntrl.text = '';
          }
        }

        final screenHeight = MediaQuery.of(context).size.height;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          top: mode == ScheduledEditMode.none ? screenHeight : 0,
          bottom: mode == ScheduledEditMode.none ? -screenHeight : 0,
          child: Material(
            color: Colors.white,
            elevation: 10,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Top bar ---
                      Row(
                        children: [
                          TextButton(
                            onPressed: repo.closeOverlay,
                            child: const Text('Cancel'),
                          ),
                          const Spacer(),
                          Text(
                            mode == ScheduledEditMode.createTask
                                ? 'Create Scheduled Task'
                                : 'Edit Scheduled Task',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _submit(context, repo),
                            child: const Text('Save'),
                          ),
                        ],
                      ),

                      if (mode == ScheduledEditMode.editTask &&
                          task != null &&
                          task.streak > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_fire_department,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              'Streak: ${task.streak}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),

                      // --- Title ---
                      TextField(
                        controller: titleCntrl,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          hintText: 'Add a title',
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- Note ---
                      TextField(
                        controller: noteCntrl,
                        decoration: const InputDecoration(
                          labelText: 'Note',
                          border: OutlineInputBorder(),
                          hintText: 'Add a note',
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- Start / anchor date ---
                      DateTimePicker(
                        selected: repo.overlayScheduledDate,
                        onChanged: repo.setOverlayScheduledDate,
                      ),
                      const SizedBox(height: 15),

                      // --- Difficulty ---
                      DifficultyPicker(
                        selected: repo.overlayDifficulty,
                        onChanged: repo.setOverlayDifficulty,
                      ),
                      const SizedBox(height: 15),

                      // --- Recurrence ---
                      const RecurrencePicker(),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: Text(
                          recurrenceSummaryFrom(
                            type: repo.overlayRecurrenceType,
                            dailyInterval: repo.overlayDailyInterval,
                            weeklyDays: repo.overlayWeeklyDays,
                            monthlySubMode: repo.overlayMonthlySubMode,
                            monthlyDayOfMonth: repo.overlayMonthlyDayOfMonth,
                            monthlyOrdinal: repo.overlayMonthlyOrdinal,
                            monthlyWeekday: repo.overlayMonthlyWeekday,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- Reminder ---
                      const ReminderPicker(),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: Text(
                          notificationSummaryFrom(
                            mode: repo.overlayReminderMode,
                            hour: repo.overlayNotificationHour,
                            minute: repo.overlayNotificationMinute,
                            minutesBefore: repo.overlayMinutesBefore,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (mode == ScheduledEditMode.editTask)
                        OutlinedButton(
                          onPressed: repo.deleteEditingTask,
                          child: const Text('Delete task'),
                        ),
                      const SizedBox(height: 8),

                      ElevatedButton(
                        onPressed: () => _submit(context, repo),
                        child: Text(
                          mode == ScheduledEditMode.createTask
                              ? 'Create'
                              : 'Save',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(
    BuildContext context,
    ScheduledTaskRepository repo,
  ) async {
    final err = await repo.saveOverlay(titleCntrl.text, noteCntrl.text);
    if (err != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }
}
