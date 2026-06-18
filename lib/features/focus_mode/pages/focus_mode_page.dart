import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/focus_mode/providers/focus_mode_provider.dart';
import 'package:bp_flutter_app/features/focus_mode/models/focus_group.dart';
import 'package:bp_flutter_app/features/focus_mode/widgets/focus_group_overlay.dart';

class FocusModePage extends StatefulWidget {
  const FocusModePage({super.key});

  @override
  State<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends State<FocusModePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FocusModeProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Mode')),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<FocusModeProvider>().openCreateOverlay(),
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Consumer<FocusModeProvider>(
            builder: (context, provider, _) {
              if (!provider.permissionsGranted) {
                return _PermissionsBanner(provider: provider);
              }
              if (provider.groups.isEmpty) {
                return const Center(
                  child:
                      Text('No focus groups yet.\nTap + to create one.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: provider.groups.length,
                itemBuilder: (context, index) {
                  final group = provider.groups[index];
                  return _FocusGroupCard(
                    group: group,
                    iconCache: provider.appIconCache,
                  );
                },
              );
            },
          ),
          const FocusGroupOverlay(),
        ],
      ),
    );
  }
}

class _PermissionsBanner extends StatelessWidget {
  const _PermissionsBanner({required this.provider});
  final FocusModeProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Focus Mode needs permissions to monitor and block apps.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Usage Access lets the app detect which app is in the foreground.\n'
              'Overlay permission lets it show the block screen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => provider.requestPermissions(),
              icon: const Icon(Icons.security),
              label: const Text('Grant Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Redesigned group card ──

class _FocusGroupCard extends StatelessWidget {
  const _FocusGroupCard({
    required this.group,
    required this.iconCache,
  });

  final FocusGroup group;
  final Map<String, Uint8List> iconCache;

  static const int _maxVisibleIcons = 4;

  @override
  Widget build(BuildContext context) {
    final isActive = group.isCurrentlyActive;
    final isLocked = group.isLocked;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<FocusModeProvider>().openViewOverlay(group);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──
              Row(
                children: [
                  Icon(
                    isActive ? Icons.lock : Icons.shield_outlined,
                    color: isActive
                        ? (group.isStrict ? Colors.red : Colors.orange)
                        : null,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Switch(
                    value: group.isEnabled,
                    onChanged: isLocked
                        ? null
                        : (_) {
                            context
                                .read<FocusModeProvider>()
                                .toggleGroupEnabled(group.id);
                          },
                  ),
                  _PopupMenu(
                    group: group,
                    isLocked: isLocked,
                  ),
                ],
              ),
              const Divider(height: 16),
              // ── Bottom row: icons + streak ──
              Row(
                children: [
                  ..._buildIconRow(),
                  const Spacer(),
                  if (group.streak > 0) _StreakBadge(streak: group.streak),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIconRow() {
    final packages = group.appPackageNames;
    if (packages.isEmpty) return [];

    final visible = packages.take(_maxVisibleIcons).toList();
    final overflow = packages.length - _maxVisibleIcons;

    final widgets = <Widget>[];
    for (int i = 0; i < visible.length; i++) {
      if (i > 0) widgets.add(const SizedBox(width: 4));
      widgets.add(_AppIcon(
        packageName: visible[i],
        iconCache: iconCache,
      ));
    }

    if (overflow > 0) {
      widgets.add(const SizedBox(width: 6));
      widgets.add(_OverflowChip(count: overflow));
    }

    return widgets;
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({
    required this.packageName,
    required this.iconCache,
  });

  final String packageName;
  final Map<String, Uint8List> iconCache;

  @override
  Widget build(BuildContext context) {
    final icon = iconCache[packageName];
    if (icon != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(icon, width: 28, height: 28),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.android, size: 18, color: Colors.grey),
    );
  }
}

class _OverflowChip extends StatelessWidget {
  const _OverflowChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '+$count',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              size: 16, color: Colors.amber),
          const SizedBox(width: 2),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    required this.group,
    required this.isLocked,
  });

  final FocusGroup group;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenu(context, value),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  void _handleMenu(BuildContext context, String action) {
    if (action == 'edit') {
      if (isLocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This strict group is currently active and cannot be modified.',
            ),
          ),
        );
        return;
      }
      context.read<FocusModeProvider>().openEditOverlay(group);
    } else if (action == 'delete') {
      if (isLocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This strict group is currently active and cannot be deleted.',
            ),
          ),
        );
        return;
      }
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
                context
                    .read<FocusModeProvider>()
                    .deleteGroup(group.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }
}
