import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';

class ReminderPicker extends StatefulWidget {
  const ReminderPicker({super.key});

  @override
  State<ReminderPicker> createState() => _ReminderPickerState();
}

class _ReminderPickerState extends State<ReminderPicker> {
  final TextEditingController _minutesCntrl = TextEditingController();
  ScheduledEditMode? _lastMode;
  int? _lastMinutesBefore;

  @override
  void dispose() {
    _minutesCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ScheduledTaskRepository>();
    final mode = repo.mode;

    // Pre-fill minutes controller when overlay mode changes or
    // minutesBefore changes from outside (e.g. reopen).
    if (_lastMode != mode || _lastMinutesBefore != repo.overlayMinutesBefore) {
      _lastMode = mode;
      _lastMinutesBefore = repo.overlayMinutesBefore;
      _minutesCntrl.text = repo.overlayMinutesBefore.toString();
    }

    const labels = {
      ReminderMode.none: 'Off',
      ReminderMode.atTime: 'At time',
      ReminderMode.minutesBefore: 'Before',
      ReminderMode.both: 'Both',
    };

    final showMinutesField =
        repo.overlayReminderMode == ReminderMode.minutesBefore ||
            repo.overlayReminderMode == ReminderMode.both;

    final showTimeField = repo.overlayReminderMode != ReminderMode.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.notifications_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ReminderMode.values.map((r) {
                  final isSelected = repo.overlayReminderMode == r;
                  return OutlinedButton(
                    onPressed: () => repo.setOverlayReminderMode(r),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.orange.withValues(alpha: 0.15)
                          : null,
                      foregroundColor:
                          isSelected ? Colors.orange : Colors.grey,
                      side: BorderSide(
                        color: isSelected ? Colors.orange : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(labels[r]!),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        if (showTimeField) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 8),
                Text(
                  repo.overlayNotificationHour != null &&
                          repo.overlayNotificationMinute != null
                      ? '${repo.overlayNotificationHour!.toString().padLeft(2, '0')}:${repo.overlayNotificationMinute!.toString().padLeft(2, '0')}'
                      : 'No time set',
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final initial = TimeOfDay(
                      hour: repo.overlayNotificationHour ?? 9,
                      minute: repo.overlayNotificationMinute ?? 0,
                    );
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: initial,
                    );
                    if (picked != null) {
                      repo.setOverlayNotificationTime(
                          picked.hour, picked.minute);
                    }
                  },
                  child: const Text('Pick time'),
                ),
              ],
            ),
          ),
        ],
        if (showMinutesField) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _minutesCntrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: 'min',
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        repo.setOverlayMinutesBefore(parsed);
                        _lastMinutesBefore = parsed;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('minutes before'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
