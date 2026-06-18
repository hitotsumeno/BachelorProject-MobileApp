import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/features/tasks/providers/task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/tasks/widgets/to_do_tile.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/scheduled_task_tile.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskRepository>().fetchTasks();
    context.read<ScheduledTaskRepository>().fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskRepo = context.watch<TaskRepository>();
    final scheduledRepo = context.watch<ScheduledTaskRepository>();
    final archivedTasks = taskRepo.archivedTasks;
    final archivedScheduled = scheduledRepo.archivedTasks;
    final isEmpty = archivedTasks.isEmpty && archivedScheduled.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: isEmpty
          ? const Center(
              child: Text(
                'No completed tasks yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              children: [
                if (archivedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25, 16, 25, 8),
                    child: Text(
                      "To-Do Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...archivedTasks.map((task) => ToDoTile(
                        task: task,
                        onChanged: (_) => taskRepo.restoreTask(task.id),
                        deleteFunction: (_) => taskRepo.deleteTask(task.id),
                        onTapEdit: null,
                      )),
                ],
                if (archivedScheduled.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25, 16, 25, 8),
                    child: Text(
                      "Scheduled Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...archivedScheduled.map((task) => ScheduledTaskTile(
                        task: task,
                        onChanged: (_) => scheduledRepo.restoreTask(task.id),
                        deleteFunction: (_) => scheduledRepo.deleteTask(task.id),
                        onTapEdit: null,
                      )),
                ],
              ],
            ),
    );
  }
}
