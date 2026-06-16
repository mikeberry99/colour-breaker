import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';

class HistoryLog extends ConsumerWidget {
  const HistoryLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final animation = ref.watch(revealAnimationProvider);
    final history = gameState.history;
    final feedbacks = gameState.feedbacks;
    final maxAttempts = gameState.maxAttempts;

    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: maxAttempts,
      itemBuilder: (context, index) {
        if (index < history.length) {
          final isAnimatingRow = animation.animatingRowIndex == index;
          final revealedColors = isAnimatingRow ? animation.revealedColors : 5;
          final pegsVisible = isAnimatingRow ? animation.pegsVisible : true;
          return _buildRow(
            context,
            index,
            history[index].colors,
            feedbacks[index].correctPositionAndColor,
            feedbacks[index].correctColorOnly,
            revealedColors: revealedColors,
            pegsVisible: pegsVisible,
            isActive: isAnimatingRow,
          );
        } else {
          final isActive = index == history.length &&
              gameState.status == GameStatus.playing &&
              !animation.isAnimating;
          return _buildEmptyRow(context, index, isActive);
        }
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    int index,
    List<GameColor> colors,
    int greenPegs,
    int yellowPegs, {
    int revealedColors = 5,
    bool pegsVisible = true,
    bool isActive = false,
  }) {
    final formattedIndex = index.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.rowGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              formattedIndex,
              style: const TextStyle(
                fontFamily: DesignTokens.labelFont,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: DesignTokens.primaryFixedDim,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF2A2A2A)
                    : Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: Container(
                      color: isActive
                          ? DesignTokens.primaryNeonCyan
                          : Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: colors.asMap().entries.map((entry) {
                            final colorIndex = entry.key;
                            final color = entry.value;
                            final revealed = colorIndex < revealedColors;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: DesignTokens.unit,
                                right: DesignTokens.unit,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: NeonOrb(
                                  key: ValueKey(revealed ? color : GameColor.empty),
                                  size: 32,
                                  gameColor: revealed ? color : GameColor.empty,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: pegsVisible ? 1.0 : 0.0,
                          child: _buildFeedback(greenPegs, yellowPegs),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRow(BuildContext context, int index, bool isActive) {
    final formattedIndex = index.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.rowGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              formattedIndex,
              style: TextStyle(
                fontFamily: DesignTokens.labelFont,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: DesignTokens.primaryFixedDim.withValues(alpha: isActive ? 0.6 : 0.3),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: Container(
                      color: isActive ? DesignTokens.primaryNeonCyan : Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(5, (_) {
                            return const Padding(
                              padding: EdgeInsets.only(
                                left: DesignTokens.unit,
                                right: DesignTokens.unit,
                              ),
                              child: NeonOrb(size: 32, gameColor: GameColor.empty),
                            );
                          }),
                        ),
                        _buildFeedback(0, 0, isEmptyRow: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(int greenPegs, int yellowPegs, {bool isEmptyRow = false}) {
    final List<_PegData> pegData = [];
    if (!isEmptyRow) {
      for (int i = 0; i < greenPegs; i++) {
        pegData.add(_PegData(DesignTokens.feedbackGreen, isGlow: true));
      }
      for (int i = 0; i < yellowPegs; i++) {
        pegData.add(_PegData(DesignTokens.feedbackYellow, isGlow: true));
      }
      for (int i = pegData.length; i < 5; i++) {
        pegData.add(_PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    } else {
      for (int i = 0; i < 5; i++) {
        pegData.add(_PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.gutter),
      child: _FeedbackRing(pegs: pegData),
    );
  }
}

// --- Supporting types ---

class _PegData {
  final Color color;
  final bool isGlow;
  const _PegData(this.color, {required this.isGlow});
}

/// Positions [pegs] evenly around a circle of [radius].
/// Widget dimensions: (radius * 2 + pegSize) × (radius * 2 + pegSize).
class _FeedbackRing extends StatelessWidget {
  final List<_PegData> pegs;
  final double radius;
  final double pegSize;

  const _FeedbackRing({
    required this.pegs,
  }) : radius = 16, pegSize = 10;

  @override
  Widget build(BuildContext context) {
    final double totalSize = radius * 2 + pegSize;
    final int count = pegs.length;

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(count, (i) {
          // Distribute evenly; -π/2 offset so first peg starts at top
          final double angle = (2 * math.pi / count) * i - math.pi / 2;
          final double dx = radius * math.cos(angle);
          final double dy = radius * math.sin(angle);
          final peg = pegs[i];

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Container(
              width: pegSize,
              height: pegSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: peg.color,
                boxShadow: peg.isGlow
                    ? [
                        BoxShadow(
                          color: peg.color.withValues(alpha: 0.6),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
