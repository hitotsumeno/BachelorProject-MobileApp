import 'package:flutter/material.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';

class DifficultyPicker extends StatelessWidget {
  final TaskDifficulty selected;
  final Function(TaskDifficulty) onChanged;

  const DifficultyPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const colors = {
      TaskDifficulty.easy:   Colors.green,
      TaskDifficulty.medium: Colors.orange,
      TaskDifficulty.hard:   Colors.red,
    };

    return Row(
      children: [
        const Icon(Icons.bar_chart),
        const SizedBox(width: 12),
        ...TaskDifficulty.values.map((d) {
          final isSelected = selected == d;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: () => onChanged(d),
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? colors[d]!.withValues(alpha: 0.15)
                    : null,
                foregroundColor: colors[d],
                side: BorderSide(
                  color: isSelected ? colors[d]! : Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(d.name),
            ),
          );
        }),
      ],
    );
  }
}