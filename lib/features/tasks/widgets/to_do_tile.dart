import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';
import 'package:bp_flutter_app/shared/widgets/custom_check_box.dart';

class ToDoTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? onTapEdit;

  const ToDoTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.deleteFunction,
    required this.onTapEdit,
  });

  Color _difficultyColor() {
    if (task.diffculty == TaskDifficulty.easy) return Colors.green;
    if (task.diffculty == TaskDifficulty.medium) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final due = task.dueDate;

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete_forever,
              backgroundColor: Colors.red.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => onTapEdit?.call(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: _difficultyColor(),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckBox(
                  value: task.isDone,
                  onChanged: onChanged,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (task.note != null && task.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.note!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      if (due != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 12, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${due.day}.${due.month}.${due.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
