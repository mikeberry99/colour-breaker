import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/glass_container.dart';
import '../../domain/entities/game_state.dart';

class GameResultOverlay extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onClose;

  const GameResultOverlay({
    super.key,
    required this.gameState,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isWin = gameState.status == GameStatus.won;
    final color = isWin ? DesignTokens.feedbackGreen : DesignTokens.feedbackYellow;
    final attempts = gameState.history.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
      child: GlassContainer(
        borderColor: color,
        isGlowing: true,
        padding: const EdgeInsets.all(DesignTokens.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (ALERT and Close Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: color,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ALERT',
                      style: TextStyle(
                        fontFamily: DesignTokens.labelFont,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onClose,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: color.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: color.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
            // Large Status Text
            Text(
              isWin ? 'SYSTEM BREACHED' : 'ACCESS DENIED',
              style: TextStyle(
                fontFamily: DesignTokens.headlineFont,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            // Subtext Description
            if (isWin) ...[
              Text(
                'Congratulations, you solved the sequence in $attempts attempts',
                style: const TextStyle(
                  fontFamily: DesignTokens.bodyFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: DesignTokens.onSurface,
                ),
              ),
              if (gameState.selectedQuote != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                    border: Border.all(
                      color: color.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$attempts',
                        style: TextStyle(
                          fontFamily: DesignTokens.headlineFont,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          gameState.selectedQuote!,
                          style: TextStyle(
                            fontFamily: DesignTokens.bodyFont,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: DesignTokens.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              const Text(
                'Mission failed. Try again',
                style: TextStyle(
                  fontFamily: DesignTokens.bodyFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: DesignTokens.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
