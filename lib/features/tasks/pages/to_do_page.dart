import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/tasks/widgets/to_do_tile.dart';
import 'package:bp_flutter_app/features/tasks/widgets/edit_task_overlay.dart';
import 'package:bp_flutter_app/features/tasks/providers/task_repository.dart';
import 'package:bp_flutter_app/features/character/widgets/character_summary_widget.dart';
import 'package:bp_flutter_app/shared/widgets/reward_toast.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskRepository>().fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<TaskRepository>();
    final tasks = repo.currentTasks;

    return Scaffold(
      floatingActionButton: Consumer<TaskRepository>(
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
              const Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 16),
                child: CharacterSummaryWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  "To Do's",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ToDoTile(
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
                        },
                      ),
              ),
            ],
          ),
          const TaskEditOverlay(),
        ],
      ),
    );
  }
}
