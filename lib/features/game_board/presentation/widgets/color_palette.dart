import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
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

class _PaletteOrb extends StatefulWidget {
  final GameColor color;

  const _PaletteOrb({required this.color, super.key});

  @override
  State<_PaletteOrb> createState() => _PaletteOrbState();
}

class _PaletteOrbState extends State<_PaletteOrb> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isHovered
                ? DesignTokens.primaryNeonCyan
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: NeonOrb(
          gameColor: widget.color,
          size: 32,
        ),
      ),
    );
  }
}
