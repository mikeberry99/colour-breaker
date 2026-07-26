import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/horizontal_hexagon_button.dart';
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

    final isMobile = isMobileBrowser;

    final fillColor = canSubmit
        ? (_isHovered
            ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.20)
            : DesignTokens.primaryNeonCyan.withValues(alpha: 0.10))
        : Colors.white.withValues(alpha: 0.03);

    final borderColor = canSubmit
        ? (_isHovered
            ? DesignTokens.primaryNeonCyan
            : DesignTokens.primaryNeonCyan.withValues(alpha: 0.6))
        : Colors.white.withValues(alpha: 0.1);

    final glowColor = canSubmit
        ? DesignTokens.primaryNeonCyan.withValues(alpha: _isHovered ? 0.4 : 0.18)
        : null;

    final textColor = canSubmit
        ? DesignTokens.primaryNeonCyan
        : Colors.white.withValues(alpha: 0.3);

    return MouseRegion(
      cursor: canSubmit ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (canSubmit) setState(() => _isHovered = true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: HorizontalHexagonButton(
        isEnabled: canSubmit,
        onTap: canSubmit
            ? () {
                final newRowIndex = ref.read(gameStateProvider).history.length;
                ref.read(gameStateProvider.notifier).submitGuess();
                ref
                    .read(revealAnimationProvider.notifier)
                    .startReveal(newRowIndex);
              }
            : null,
        fillColor: fillColor,
        borderColor: borderColor,
        glowColor: glowColor,
        glowBlurRadius: _isHovered ? 20 : 15,
        borderWidth: 2,
        cutWidthRatio: 0.25,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 8,
          vertical: 12,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            isMobile ? 'LOAD' : 'LOAD HACK',
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontFamily: DesignTokens.labelFont,
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              height: 1.4,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

