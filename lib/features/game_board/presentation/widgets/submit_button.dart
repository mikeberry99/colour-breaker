import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';

class SubmitButton extends ConsumerWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final canSubmit = gameState.activeGuess.isCompleteFor(gameState.slotCount) &&
        gameState.status == GameStatus.playing;

    return GestureDetector(
      onTap: canSubmit
          ? () {
              final newRowIndex = ref.read(gameStateProvider).history.length;
              ref.read(gameStateProvider.notifier).submitGuess();
              ref
                  .read(revealAnimationProvider.notifier)
                  .startReveal(newRowIndex);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: canSubmit
                ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: canSubmit
              ? [
                  BoxShadow(
                    color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.15),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Text(
          'LOAD HACK',
          textAlign: TextAlign.center,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontFamily: DesignTokens.labelFont,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            height: 1.4,
            color: canSubmit
                ? DesignTokens.primaryNeonCyan
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
