import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_color.dart';
import '../providers/game_provider.dart';

class ColorPalette extends ConsumerWidget {
  const ColorPalette({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validColors =
        GameColor.values.where((c) => c != GameColor.empty).toList();

    // Pill container — matches Stitch: bg-surface-container-lowest, border outline-variant/30
    // flex-shrink-0: natural intrinsic width, does NOT expand (SubmitButton gets Expanded instead)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E0E), // surface-container-lowest
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF3B494B)
              .withValues(alpha: 0.3), // outline-variant/30
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: validColors.map((color) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () =>
                  ref.read(gameStateProvider.notifier).addColor(color),
              child: _PaletteOrb(color: color),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaletteOrb extends StatelessWidget {
  final GameColor color;

  const _PaletteOrb({required this.color});

  @override
  Widget build(BuildContext context) {
    return NeonOrb(
      gameColor: color,
      size: 40,
    );
  }
}
