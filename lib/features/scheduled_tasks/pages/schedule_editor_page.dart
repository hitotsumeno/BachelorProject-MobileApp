import 'package:flutter/material.dart';
import 'package:bp_flutter_app/features/focus_mode/models/focus_group.dart';
import 'package:bp_flutter_app/features/focus_mode/providers/focus_mode_provider.dart';

/// Edits the schedule (time windows + active days) for a FocusGroup.
/// Returns the updated group via Navigator.pop.
class ScheduleEditorPage extends StatefulWidget {
  const ScheduleEditorPage({
    super.key,
    required this.timeWindows,
    required this.activeDays,
  });

  final List<FocusTimeWindow> timeWindows;
  final List<int> activeDays;

  @override
  State<ScheduleEditorPage> createState() => _ScheduleEditorPageState();
}

class _ScheduleEditorPageState extends State<ScheduleEditorPage> {
  late List<FocusTimeWindow> _windows;
  late List<int> _days;
  String? _error;

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const _presets = {
    'Work hours': (9, 0, 17, 0),
    'Evening': (18, 0, 22, 0),
    'Sleep': (22, 0, 7, 0),
  };

  @override
  void initState() {
    super.initState();
    _windows = widget.timeWindows
        .map((w) => FocusTimeWindow()
          ..startHour = w.startHour
          ..startMinute = w.startMinute
          ..endHour = w.endHour
          ..endMinute = w.endMinute)
        .toList();
    _days = List.from(widget.activeDays);
  }

  void _addWindow(int sh, int sm, int eh, int em) {
    final w = FocusTimeWindow()
      ..startHour = sh
      ..startMinute = sm
      ..endHour = eh
      ..endMinute = em;
    setState(() {
      _windows.add(w);
      _validate();
    });
  }

  void _removeWindow(int index) {
    setState(() {
      _windows.removeAt(index);
      _validate();
    });
  }

  void _validate() {
    _error = FocusModeProvider.validateTimeWindows(_windows);
  }

  void _save() {
    _validate();
    if (_error != null) return;
    Navigator.pop(context, {
      'windows': _windows,
      'days': _days,
    });
  }

  Future<void> _pickTime(bool isStart, int index) async {
    final w = _windows[index];
    final initial = isStart
        ? TimeOfDay(hour: w.startHour, minute: w.startMinute)
        : TimeOfDay(hour: w.endHour, minute: w.endMinute);

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    setState(() {
      if (isStart) {
        w.startHour = picked.hour;
        w.startMinute = picked.minute;
      } else {
        w.endHour = picked.hour;
        w.endMinute = picked.minute;
      }
      _validate();
    });
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Schedule'),
        actions: [
          TextButton(
            onPressed: _error == null ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Active days ──
          const Text('Active Days',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(7, (i) {
              final dayNum = i + 1; // 1=Mon .. 7=Sun
              final selected = _days.contains(dayNum);
              return FilterChip(
                label: Text(_dayLabels[i]),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _days.add(dayNum);
                    } else {
                      _days.remove(dayNum);
                    }
                  });
                },
              );
            }),
          ),

          const SizedBox(height: 24),

          // ── Presets ──
          const Text('Quick Presets',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _presets.entries.map((entry) {
              final (sh, sm, eh, em) = entry.value;
              return ActionChip(
                label: Text(entry.key),
                onPressed: () => _addWindow(sh, sm, eh, em),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Time windows list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Time Windows',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => _addWindow(9, 0, 17, 0),
                icon: const Icon(Icons.add),
                tooltip: 'Add custom window',
              ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ),
          if (_windows.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No time windows. Add one above.'),
            ),
          ..._windows.asMap().entries.map((entry) {
            final i = entry.key;
            final w = entry.value;
            return Card(
              child: ListTile(
                title: Text(
                  '${_formatTime(w.startHour, w.startMinute)} – '
                  '${_formatTime(w.endHour, w.endMinute)}'
                  '${w.spansNextDay ? " (next day)" : ""}',
                ),
                leading: const Icon(Icons.schedule),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _removeWindow(i),
                ),
                onTap: () async {
                  await _pickTime(true, i);
                  if (mounted) await _pickTime(false, i);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
