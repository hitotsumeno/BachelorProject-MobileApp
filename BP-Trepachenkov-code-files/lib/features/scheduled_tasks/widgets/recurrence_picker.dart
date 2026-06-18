import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';

class RecurrencePicker extends StatelessWidget {
  const RecurrencePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ScheduledTaskRepository>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.repeat),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RecurrenceType.values.map((r) {
                  final isSelected = repo.overlayRecurrenceType == r;
                  return OutlinedButton(
                    onPressed: () => repo.setOverlayRecurrenceType(r),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.blue.withValues(alpha: 0.15)
                          : null,
                      foregroundColor: isSelected ? Colors.blue : Colors.grey,
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(_typeLabel(r)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: _buildSubEditor(repo),
        ),
      ],
    );
  }

  static String _typeLabel(RecurrenceType r) {
    switch (r) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
    }
  }

  Widget _buildSubEditor(ScheduledTaskRepository repo) {
    switch (repo.overlayRecurrenceType) {
      case RecurrenceType.daily:
        return _DailySubEditor(
          interval: repo.overlayDailyInterval,
          onChanged: repo.setOverlayDailyInterval,
        );
      case RecurrenceType.weekly:
        return _WeeklySubEditor(
          selected: repo.overlayWeeklyDays,
          onToggle: repo.toggleOverlayWeeklyDay,
          onPreset: repo.setOverlayWeeklyDays,
        );
      case RecurrenceType.monthly:
        return _MonthlySubEditor(repo: repo);
    }
  }
}

class _DailySubEditor extends StatelessWidget {
  const _DailySubEditor({required this.interval, required this.onChanged});
  final int interval;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Every'),
        const SizedBox(width: 8),
        IconButton(
          onPressed: interval > 1 ? () => onChanged(interval - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 32,
          child: Text('$interval', textAlign: TextAlign.center),
        ),
        IconButton(
          onPressed: interval < 30 ? () => onChanged(interval + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
        const SizedBox(width: 4),
        Text(interval == 1 ? 'day' : 'days'),
      ],
    );
  }
}

class _WeeklySubEditor extends StatelessWidget {
  const _WeeklySubEditor({
    required this.selected,
    required this.onToggle,
    required this.onPreset,
  });
  final List<int> selected;
  final ValueChanged<int> onToggle;
  final ValueChanged<List<int>> onPreset;

  static const _labels = ['', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(7, (i) {
            final weekday = i + 1;
            final isOn = selected.contains(weekday);
            return ChoiceChip(
              label: Text(_labels[weekday]),
              selected: isOn,
              onSelected: (_) => onToggle(weekday),
            );
          }),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            TextButton(
              onPressed: () => onPreset(const [1, 2, 3, 4, 5]),
              child: const Text('Weekdays'),
            ),
            TextButton(
              onPressed: () => onPreset(const [6, 7]),
              child: const Text('Weekends'),
            ),
            TextButton(
              onPressed: () => onPreset(const [1, 2, 3, 4, 5, 6, 7]),
              child: const Text('Every day'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MonthlySubEditor extends StatelessWidget {
  const _MonthlySubEditor({required this.repo});
  final ScheduledTaskRepository repo;

  static const _weekdayShort = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _ordinalLabel = {
    MonthlyOrdinal.first: '1st',
    MonthlyOrdinal.second: '2nd',
    MonthlyOrdinal.third: '3rd',
    MonthlyOrdinal.fourth: '4th',
    MonthlyOrdinal.last: 'Last',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<MonthlySubMode>(
          segments: const [
            ButtonSegment(
              value: MonthlySubMode.byDate,
              label: Text('By date'),
            ),
            ButtonSegment(
              value: MonthlySubMode.byOrdinalWeekday,
              label: Text('By weekday'),
            ),
          ],
          selected: {repo.overlayMonthlySubMode},
          onSelectionChanged: (s) =>
              repo.setOverlayMonthlySubMode(s.first),
        ),
        const SizedBox(height: 8),
        if (repo.overlayMonthlySubMode == MonthlySubMode.byDate)
          Row(
            children: [
              const Text('Day'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: repo.overlayMonthlyDayOfMonth ?? 1,
                items: List.generate(31, (i) => i + 1)
                    .map((d) =>
                        DropdownMenuItem(value: d, child: Text('$d')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) repo.setOverlayMonthlyDayOfMonth(v);
                },
              ),
            ],
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DropdownButton<MonthlyOrdinal>(
                value: repo.overlayMonthlyOrdinal,
                items: MonthlyOrdinal.values
                    .map((o) => DropdownMenuItem(
                          value: o,
                          child: Text(_ordinalLabel[o]!),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) repo.setOverlayMonthlyOrdinal(v);
                },
              ),
              DropdownButton<int>(
                value: repo.overlayMonthlyWeekday ?? DateTime.monday,
                items: List.generate(7, (i) => i + 1)
                    .map((wd) => DropdownMenuItem(
                          value: wd,
                          child: Text(_weekdayShort[wd]),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) repo.setOverlayMonthlyWeekday(v);
                },
              ),
            ],
          ),
      ],
    );
  }
}
