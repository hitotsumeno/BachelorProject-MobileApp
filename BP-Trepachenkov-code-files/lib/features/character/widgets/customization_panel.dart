import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/character/models/character.dart';
import 'package:bp_flutter_app/features/character/models/character_customization.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';

/// Scrollable customization UI: skin selector, per-slot equipment pickers,
/// and an accent-color palette. Reads current selections from
/// [CharacterNotifier] and writes changes back through it.
class CustomizationPanel extends StatelessWidget {
  const CustomizationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterNotifier>(
      builder: (context, notifier, _) {
        final character = notifier.character;
        final accent = Color(character.accentColorValue);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Appearance', accent: accent),
            const SizedBox(height: 8),
            _SkinRow(character: character, accent: accent, notifier: notifier),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Equipment', accent: accent),
            const SizedBox(height: 8),
            for (final slot in EquipmentSlot.values) ...[
              _EquipmentSlotRow(
                slot: slot,
                character: character,
                accent: accent,
                notifier: notifier,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            _SectionHeader(title: 'Accent color', accent: accent),
            const SizedBox(height: 8),
            _ColorPalette(selected: accent, notifier: notifier),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.accent});

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SkinRow extends StatelessWidget {
  const _SkinRow({
    required this.character,
    required this.accent,
    required this.notifier,
  });

  final Character character;
  final Color accent;
  final CharacterNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CharacterAssetRegistry.skins.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final skin = CharacterAssetRegistry.skins[index];
          final selected = skin.id == character.selectedSkinId;
          return _OptionCard(
            label: skin.name,
            icon: Icons.person_outline,
            selected: selected,
            accent: accent,
            onTap: () => notifier.updateCustomization(skinId: skin.id),
          );
        },
      ),
    );
  }
}

class _EquipmentSlotRow extends StatelessWidget {
  const _EquipmentSlotRow({
    required this.slot,
    required this.character,
    required this.accent,
    required this.notifier,
  });

  final EquipmentSlot slot;
  final Character character;
  final Color accent;
  final CharacterNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final items = CharacterAssetRegistry.itemsForSlot(slot);
    // Gracefully hide a slot that only has the synthetic "None" option.
    if (items.length <= 1) return const SizedBox.shrink();

    final equippedId = notifier.equippedIdFor(slot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(slot.icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 6),
            Text(
              slot.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final selected = item.id == equippedId;
              return _OptionCard(
                label: item.name,
                icon: item.icon,
                selected: selected,
                accent: accent,
                onTap: () => notifier.setEquipment(slot, item.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette({required this.selected, required this.notifier});

  final Color selected;
  final CharacterNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final selectedValue = selected.toARGB32();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final color in CharacterAssetRegistry.colorPalette)
          _ColorSwatch(
            color: color,
            selected: color.toARGB32() == selectedValue,
            onTap: () => notifier.updateCustomization(
              accentColorValue: color.toARGB32(),
            ),
          ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.black87 : Colors.white,
            width: selected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: selected
            ? const Icon(Icons.check, size: 20, color: Colors.white)
            : null,
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 88,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? accent : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: selected ? accent : Colors.grey.shade700,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? accent : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
