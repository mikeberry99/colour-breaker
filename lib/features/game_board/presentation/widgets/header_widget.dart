import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final notifier = ref.read(gameStateProvider.notifier);
    final animation = ref.watch(revealAnimationProvider);
    // DEBUG: always show solution — remove debugSolution and restore revealedSolution for production
    final debugSolution = notifier.debugSolution;
    final isGameOver = gameState.status != GameStatus.playing && !animation.isAnimating;

    return Column(
      children: [
        const SizedBox(height: DesignTokens.marginDesktop),
        Text(
          'CODE HACKER',
          style: GoogleFonts.sora(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.05,
            color: DesignTokens.primaryNeonCyan,
          ),
        ),
        const SizedBox(height: DesignTokens.rowGap),
        // Debug: solution always shown with a label
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: const Text(
                '🔓 DEBUG: SOLUTION VISIBLE',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontFamily: 'JetBrains Mono',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Slots styled identically to ActiveGuessRow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(debugSolution.colors.length, (index) {
                final color = debugSolution.colors[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.8),
                        width: 2,
                      ),
                    ),
                    child: NeonOrb(
                      size: 32,
                      gameColor: color,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        if (isGameOver)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.gutter),
            child: Text(
              gameState.status == GameStatus.won ? 'SYSTEM BREACHED' : 'ACCESS DENIED',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: gameState.status == GameStatus.won 
                    ? DesignTokens.feedbackGreen 
                    : DesignTokens.feedbackYellow, // or Red
              ),
            ),
          ),
      ],
    );
  }
}
