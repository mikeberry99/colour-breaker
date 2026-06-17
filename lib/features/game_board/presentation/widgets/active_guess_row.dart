import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../../../core/ui/dashed_circle.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';

class ActiveGuessRow extends ConsumerWidget {
  const ActiveGuessRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final activeGuess = gameState.activeGuess;
    final isPlaying = gameState.status == GameStatus.playing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Slots with dashed cyan ring, matching Stitch design
        ...List.generate(gameState.slotCount, (index) {
          final hasColor = index < activeGuess.colors.length;
          final color = hasColor ? activeGuess.colors[index] : GameColor.empty;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: hasColor && isPlaying
                  ? () {
                      // tap a filled slot to remove it (remove from index onwards)
                      ref.read(gameStateProvider.notifier).removeColor();
                    }
                  : null,
              child: TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 200),
                tween: ColorTween(
                  begin: DesignTokens.primaryNeonCyan.withValues(alpha: 0.4),
                  end: hasColor
                      ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.8)
                      : DesignTokens.primaryNeonCyan.withValues(alpha: 0.4),
                ),
                builder: (context, animatedColor, child) {
                  return CustomPaint(
                    painter: DashedCirclePainter(
                      color: animatedColor ??
                          DesignTokens.primaryNeonCyan.withValues(alpha: 0.4),
                      strokeWidth: 2,
                      dashCount: 16,
                    ),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Center(
                        child: NeonOrb(
                          size: 32,
                          gameColor: color,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
