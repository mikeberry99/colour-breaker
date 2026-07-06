import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';

class ColorPalette extends ConsumerWidget {
  const ColorPalette({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final isEnabled = gameState.status == GameStatus.playing &&
        gameState.activeGuess.colors.length < gameState.slotCount;

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
          color: DesignTokens.outlineVariant
              .withValues(alpha: 0.3), // outline-variant/30
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: validColors.map((color) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Semantics(
              label: '${color.name} colour',
              button: isEnabled,
              child: GestureDetector(
                onTap: isEnabled
                    ? () => ref.read(gameStateProvider.notifier).addColor(color)
                    : null,
                child: _PaletteOrb(
                  color: color,
                  isEnabled: isEnabled,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaletteOrb extends StatefulWidget {
  final GameColor color;
  final bool isEnabled;

  const _PaletteOrb({
    required this.color,
    required this.isEnabled,
  });

  @override
  State<_PaletteOrb> createState() => _PaletteOrbState();
}

class _PaletteOrbState extends State<_PaletteOrb> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showHover = widget.isEnabled && _isHovered;
    final cursor = widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic;

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) {
        if (widget.isEnabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.isEnabled ? 1.0 : 0.4,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: showHover
                  ? DesignTokens.primaryNeonCyan
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: showHover
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
            size: 38,
          ),
        ),
      ),
    );
  }
}
