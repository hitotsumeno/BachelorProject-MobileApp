import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onChanged;

  const DateTimePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final date = selected;

    return Column(
      children: [
        // — Date row —
        Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null
                    ? "No date set"
                    : "${date.day}.${date.month}.${date.year}",
              ),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked == null) return;

                // Preserve existing time if already set, otherwise default to 00:00
                final existingTime = date != null
                    ? TimeOfDay(hour: date.hour, minute: date.minute)
                    : const TimeOfDay(hour: 0, minute: 0);

                final combined = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  existingTime.hour,
                  existingTime.minute,
                );
                onChanged(combined);
              },
              child: const Text("Pick date"),
            ),
            if (date != null)
              IconButton(
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close, size: 18),
              ),
          ],
        ),

        // — Time row — only visible if date is set
        if (date != null)
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (!context.mounted) return;
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: date.hour, minute: date.minute),
                  );
                  if (picked == null) return;

                  final combined = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    picked.hour,
                    picked.minute,
                  );
                  onChanged(combined);
                },
                child: const Text("Pick time"),
              ),
            ],
          ),
      ],
    );
  }
}
