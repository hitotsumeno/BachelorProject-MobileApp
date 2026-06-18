import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';
import 'package:bp_flutter_app/features/character/widgets/stat_bar_widget.dart';
import 'package:bp_flutter_app/features/character/widgets/character_3d_viewer.dart';
import 'package:bp_flutter_app/features/character/widgets/customization_panel.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterNotifier>(
      builder: (context, notifier, _) {
        final c = notifier.character;
        final accent = Color(c.accentColorValue);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D character viewer (reads skin + equipment from CharacterNotifier)
              Character3DViewer(accentColor: accent),

              const SizedBox(height: 24),

              // Name + Level
              Text(
                c.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level ${c.level}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              // Health bar
              StatBarWidget(
                label: 'Health',
                value: c.currentHealth,
                max: c.maxHealth,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              // XP bar
              StatBarWidget(
                label: 'Experience',
                value: c.currentXP,
                max: c.xpToNextLevel,
                color: Colors.amber,
              ),
              Text(
                'Next level in ${c.xpToNextLevel - c.currentXP} XP',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),

              const SizedBox(height: 16),

              // Mana bar
              StatBarWidget(
                label: 'Mana',
                value: c.mana,
                max: c.maxMana,
                color: Colors.blue,
              ),

              const SizedBox(height: 24),

              // Gold
              Row(
                children: [
                  Icon(Icons.monetization_on,
                      color: Colors.amber.shade700, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    '${c.gold} Gold',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Customization panel
              const CustomizationPanel(),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
