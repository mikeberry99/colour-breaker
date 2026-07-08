import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';

class SubmitButton extends ConsumerStatefulWidget {
  const SubmitButton({super.key});

  @override
  ConsumerState<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final canSubmit = gameState.activeGuess.isCompleteFor(gameState.slotCount) &&
        gameState.status == GameStatus.playing;

    final cursor = canSubmit ? SystemMouseCursors.click : SystemMouseCursors.basic;

    final isMobile = isMobileBrowser;

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) {
        if (canSubmit) setState(() => _isHovered = true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
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
            color: canSubmit && _isHovered
                ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(
              color: canSubmit
                  ? (_isHovered
                      ? DesignTokens.primaryNeonCyan
                      : DesignTokens.primaryNeonCyan.withValues(alpha: 0.6))
                  : Colors.white.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: canSubmit
                ? [
                    BoxShadow(
                      color: DesignTokens.primaryNeonCyan.withValues(
                        alpha: _isHovered ? 0.35 : 0.15,
                      ),
                      blurRadius: _isHovered ? 20 : 15,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Text(
            isMobile ? 'LOAD' : 'LOAD HACK',
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
      ),
    );
  }
}
