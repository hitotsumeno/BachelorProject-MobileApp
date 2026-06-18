import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/tasks/providers/task_repository.dart';

class DueDatePicker extends StatelessWidget {
  const DueDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<TaskRepository>();
    final selectedDueDate = repo.overlayDueDate;

    return Row(
      children: [
        const Icon(Icons.calendar_today),
        const SizedBox(width: 12,),
        Expanded(
          child: Text(
            selectedDueDate == null
              ? "No due date"
              : "${selectedDueDate.day}.${selectedDueDate.month}.${selectedDueDate.year}",
          ),
        ),
        TextButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context, 
              initialDate: selectedDueDate ?? DateTime.now(),
              firstDate: DateTime(2000), 
              lastDate: DateTime(2100),
              confirmText: "Confirm",
            );
            if (picked != null){
              // selectedDueDate = picked;
              repo.setOverlayDueDate(picked);
            }
          }, 
          child: const Text("Pick date"), 
        ),
      ],
    );
  }
}