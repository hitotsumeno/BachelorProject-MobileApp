import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/focus_mode/models/focus_group.dart';
import 'package:bp_flutter_app/features/focus_mode/providers/focus_mode_provider.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/pages/schedule_editor_page.dart';
import 'package:bp_flutter_app/features/focus_mode/widgets/app_picker_dialog.dart';

class FocusGroupOverlay extends StatefulWidget {
  const FocusGroupOverlay({super.key});

  @override
  State<FocusGroupOverlay> createState() => _FocusGroupOverlayState();
}

class _FocusGroupOverlayState extends State<FocusGroupOverlay> {
  final TextEditingController _nameController = TextEditingController();
  FocusEditMode? _lastMode;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickApps(FocusModeProvider provider) async {
    final group = provider.editingGroup;
    if (group == null) return;
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AppPickerDialog(
          alreadySelected: group.appPackageNames,
        ),
      ),
    );
    if (result == null) return;
    group.appPackageNames = result;
    provider.updateEditingGroup(group);
  }

  Future<void> _editSchedule(FocusModeProvider provider) async {
    final group = provider.editingGroup;
    if (group == null) return;
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleEditorPage(
          timeWindows: group.timeWindows,
          activeDays: group.activeDays,
        ),
      ),
    );
    if (result == null) return;
    group.timeWindows = (result['windows'] as List).cast<FocusTimeWindow>();
    group.activeDays = (result['days'] as List).cast<int>();
    provider.updateEditingGroup(group);
  }

  Future<void> _save(FocusModeProvider provider) async {
    final group = provider.editingGroup;
    if (group == null) return;
    group.name = _nameController.text.trim();

    final overlap = FocusModeProvider.validateTimeWindows(group.timeWindows);
    if (overlap != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(overlap)));
      return;
    }
    if (!FocusModeProvider.canSaveGroup(group)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Group needs a name, at least one app, day, and time window.'),
        ),
      );
      return;
    }
    await provider.saveOverlay();
  }

  void _confirmLiftStrict(FocusModeProvider provider, FocusGroup group) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lift Strict Mode'),
        content: Text(
          'This will permanently reset "${group.name}" streak '
          'from ${group.streak} day${group.streak == 1 ? '' : 's'} to 0.\n\n'
          'The group will become non-strict immediately. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.liftStrictMode(group.id);
            },
            child: const Text(
              'Lift Strict Mode',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(FocusModeProvider provider, FocusGroup group) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Delete "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteEditingGroup();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusModeProvider>(
      builder: (context, provider, _) {
        final mode = provider.mode;
        final group = provider.editingGroup;
        final isViewOnly = mode == FocusEditMode.viewGroup;

        // Sync text controller when mode changes
        if (_lastMode != mode) {
          _lastMode = mode;
          if ((mode == FocusEditMode.editGroup ||
                  mode == FocusEditMode.viewGroup) &&
              group != null) {
            _nameController.text = group.name;
          }
          if (mode == FocusEditMode.createGroup) {
            _nameController.text = '';
          }
        }

        final screenHeight = MediaQuery.of(context).size.height;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          top: mode == FocusEditMode.none ? screenHeight : 0,
          bottom: mode == FocusEditMode.none ? -screenHeight : 0,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 10,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ── Header ──
                    _buildHeader(provider, mode, group, isViewOnly),
                    const SizedBox(height: 16),

                    // ── Scrollable content ──
                    Expanded(
                      child: ListView(
                        children: [
                          // ── Streak display ──
                          if (mode != FocusEditMode.createGroup &&
                              group != null) ...[
                            _StreakBanner(streak: group.streak),
                            const SizedBox(height: 16),
                          ],

                          // ── Name ──
                          TextField(
                            controller: _nameController,
                            readOnly: isViewOnly,
                            decoration: const InputDecoration(
                              labelText: 'Group Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Apps ──
                          _SectionHeader(
                            title:
                                'Blocked Apps (${group?.appPackageNames.length ?? 0} selected)',
                            actionLabel: isViewOnly ? null : 'Pick',
                            onAction:
                                isViewOnly ? null : () => _pickApps(provider),
                          ),
                          if (group != null &&
                              group.appPackageNames.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children:
                                  group.appPackageNames.map((pkg) {
                                final idx =
                                    group.appPackageNames.indexOf(pkg);
                                final name =
                                    idx < group.appDisplayNames.length
                                        ? group.appDisplayNames[idx]
                                        : pkg.split('.').last;
                                return Chip(
                                  label: Text(name,
                                      style: const TextStyle(fontSize: 12)),
                                  onDeleted: isViewOnly
                                      ? null
                                      : () {
                                          group.appPackageNames.removeAt(idx);
                                          if (idx <
                                              group.appDisplayNames.length) {
                                            group.appDisplayNames
                                                .removeAt(idx);
                                          }
                                          provider
                                              .updateEditingGroup(group);
                                        },
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 20),

                          // ── Schedule ──
                          _SectionHeader(
                            title:
                                'Schedule (${group?.timeWindows.length ?? 0} windows, '
                                '${group?.activeDays.length ?? 0} days)',
                            actionLabel: isViewOnly ? null : 'Edit',
                            onAction: isViewOnly
                                ? null
                                : () => _editSchedule(provider),
                          ),
                          if (group != null)
                            ...(group.timeWindows.map((w) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 4),
                                child: Text(
                                  '${_fmt(w.startHour, w.startMinute)} – '
                                  '${_fmt(w.endHour, w.endMinute)}'
                                  '${w.spansNextDay ? " (next day)" : ""}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            })),
                          const SizedBox(height: 20),

                          // ── Strict mode ──
                          SwitchListTile(
                            title: const Text('Strict Mode'),
                            subtitle: const Text(
                              'When active, this group cannot be edited or deleted.',
                            ),
                            value: group?.isStrict ?? false,
                            onChanged: isViewOnly
                                ? null
                                : (val) {
                                    if (group == null) return;
                                    group.isStrict = val;
                                    provider.updateEditingGroup(group);
                                  },
                          ),

                          // ── Lift strict mode (only for editing a strict group) ──
                          if (!isViewOnly &&
                              mode == FocusEditMode.editGroup &&
                              group != null &&
                              group.isStrict)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _confirmLiftStrict(provider, group),
                                icon: const Icon(Icons.lock_open,
                                    color: Colors.red),
                                label: const Text(
                                  'Lift Strict Mode (resets streak)',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          // ── Intervals (non-strict only) ──
                          if (group != null && !group.isStrict)
                            _IntervalSection(
                              group: group,
                              isViewOnly: isViewOnly,
                              onChanged: () =>
                                  provider.updateEditingGroup(group),
                            ),

                          // ── Enabled toggle ──
                          SwitchListTile(
                            title: const Text('Enabled'),
                            subtitle:
                                const Text('Master on/off for this group.'),
                            value: group?.isEnabled ?? true,
                            onChanged: isViewOnly
                                ? null
                                : (val) {
                                    if (group == null) return;
                                    group.isEnabled = val;
                                    provider.updateEditingGroup(group);
                                  },
                          ),

                          const SizedBox(height: 20),

                          // ── Delete ──
                          if (!isViewOnly &&
                              mode == FocusEditMode.editGroup &&
                              group != null)
                            OutlinedButton(
                              onPressed: () =>
                                  _confirmDelete(provider, group),
                              child: const Text('Delete Group'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    FocusModeProvider provider,
    FocusEditMode mode,
    FocusGroup? group,
    bool isViewOnly,
  ) {
    if (isViewOnly) {
      return Row(
        children: [
          TextButton(
            onPressed: provider.closeOverlay,
            child: const Text('Close'),
          ),
          const Spacer(),
          const Text(
            'Group Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              if (group != null && group.isLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'This strict group is currently active and cannot be edited.',
                    ),
                  ),
                );
                return;
              }
              if (group != null) {
                provider.openEditOverlay(group);
              }
            },
            child: const Text('Edit'),
          ),
        ],
      );
    }

    return Row(
      children: [
        TextButton(
          onPressed: provider.closeOverlay,
          child: const Text('Cancel'),
        ),
        const Spacer(),
        Text(
          mode == FocusEditMode.createGroup ? 'New Focus Group' : 'Edit Group',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _save(provider),
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _fmt(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: streak > 0
            ? Colors.amber.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: streak > 0 ? Colors.amber : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            '$streak day${streak == 1 ? '' : 's'} streak',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: streak > 0 ? Colors.amber.shade800 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _IntervalSection extends StatelessWidget {
  const _IntervalSection({
    required this.group,
    required this.isViewOnly,
    required this.onChanged,
  });

  final FocusGroup group;
  final bool isViewOnly;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (isViewOnly) {
      final label = group.intervalsPerDay > 0
          ? '${group.intervalsPerDay} intervals of ${group.intervalLengthMinutes} min/day'
          : 'Disabled';
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          title: const Text('Timed Intervals'),
          subtitle: Text(label),
          contentPadding: EdgeInsets.zero,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Timed Intervals',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'Free breaks that don\'t affect your streak.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _StepperRow(
            label: 'Intervals per day',
            value: group.intervalsPerDay,
            min: 0,
            max: 10,
            displayValue: group.intervalsPerDay == 0
                ? 'Off'
                : '${group.intervalsPerDay}',
            onChanged: (val) {
              group.intervalsPerDay = val;
              onChanged();
            },
          ),
          if (group.intervalsPerDay > 0) ...[
            const SizedBox(height: 8),
            _StepperRow(
              label: 'Interval length',
              value: group.intervalLengthMinutes,
              min: 3,
              max: 15,
              displayValue: '${group.intervalLengthMinutes} min',
              onChanged: (val) {
                group.intervalLengthMinutes = val;
                onChanged();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final String displayValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: 20,
        ),
        SizedBox(
          width: 48,
          child: Text(displayValue, textAlign: TextAlign.center),
        ),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 20,
        ),
      ],
    );
  }
}
