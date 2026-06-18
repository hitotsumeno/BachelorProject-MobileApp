import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';

class CharacterSummaryWidget extends StatelessWidget {
  const CharacterSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterNotifier>(
      builder: (context, notifier, _) {
        final c = notifier.character;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Name + Level
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Lv. ${c.level}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // XP bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XP: ${c.currentXP} / ${c.xpToNextLevel}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: c.xpPercent.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // HP + Gold
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'HP: ${c.currentHealth} / ${c.maxHealth}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.monetization_on, size: 14, color: Colors.amber.shade700),
                      const SizedBox(width: 2),
                      Text(
                        '${c.gold}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
