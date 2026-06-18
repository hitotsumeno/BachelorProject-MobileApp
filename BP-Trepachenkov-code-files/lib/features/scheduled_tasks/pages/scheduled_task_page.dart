import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/models/scheduled_task.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/scheduled_task_overlay.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/scheduled_task_tile.dart';
import 'package:bp_flutter_app/features/character/widgets/character_summary_widget.dart';
import 'package:bp_flutter_app/shared/widgets/reward_toast.dart';

class ScheduledTaskPage extends StatefulWidget {
  const ScheduledTaskPage({super.key});

  @override
  State<ScheduledTaskPage> createState() => _ScheduledTaskPageState();
}

class _ScheduledTaskPageState extends State<ScheduledTaskPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduledTaskRepository>().fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ScheduledTaskRepository>();
    final today = DateTime.now();
    final all = repo.currentTasks;
    final todayTasks =
        all.where((t) => t.isActiveOn(today)).toList(growable: false);
    final notTodayTasks =
        all.where((t) => !t.isActiveOn(today)).toList(growable: false);

    return Scaffold(
      floatingActionButton: Consumer<ScheduledTaskRepository>(
        builder: (context, repo, _) {
          final isDisabled = repo.isOverlayOpen;
          return FloatingActionButton(
            onPressed: isDisabled ? null : repo.openCreate,
            child: const Icon(Icons.add),
          );
        },
      ),

      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character summary
              const Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 16),
                child: CharacterSummaryWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Scheduled Tasks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: all.isEmpty
                    ? const Center(
                        child: Text(
                          'No scheduled tasks yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView(
                        children: [
                          if (todayTasks.isNotEmpty) ...[
                            const _SectionHeader(label: 'Today'),
                            ...todayTasks.map(
                              (t) => _tileFor(context, repo, t),
                            ),
                          ],
                          if (notTodayTasks.isNotEmpty) ...[
                            const _SectionHeader(label: 'Not today'),
                            ...notTodayTasks.map(
                              (t) => _tileFor(context, repo, t),
                            ),
                          ],
                          const SizedBox(height: 96),
                        ],
                      ),
              ),
            ],
          ),
          const ScheduledTaskOverlay(),
        ],
      ),
    );
  }

  Widget _tileFor(
    BuildContext context,
    ScheduledTaskRepository repo,
    ScheduledTask task,
  ) {
    return ScheduledTaskTile(
      key: ValueKey(task.id),
      task: task,
      onChanged: (_) async {
        final reward = await repo.toggleTask(task.id);
        if (reward != null && context.mounted) {
          RewardToast.show(context, reward);
        }
      },
      deleteFunction: (_) => repo.deleteTask(task.id),
      onTapEdit: (_) => repo.openEdit(task),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
