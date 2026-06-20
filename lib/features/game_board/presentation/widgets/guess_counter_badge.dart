import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/security_protocol.dart';
import '../providers/game_provider.dart';

class GuessCounterBadge extends ConsumerWidget {
  const GuessCounterBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    final isNovice = gameState.protocol == SecurityProtocol.novice;
    final remaining = isNovice ? null : gameState.absoluteMaxAttempts - gameState.history.length;
    final total = isNovice ? null : gameState.absoluteMaxAttempts;

    final counterText = isNovice ? '∞' : '$remaining/$total';

    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0x08FFFFFF), // Matches Stitch glass-card background
            borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
            border: Border.all(
              color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_outlined,
                color: DesignTokens.primaryNeonCyan,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                counterText,
                style: const TextStyle(
                  fontFamily: DesignTokens.labelFont,
                  color: DesignTokens.primaryNeonCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
