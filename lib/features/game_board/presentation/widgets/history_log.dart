import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/security_protocol.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';
import 'feedback_pegs_widget.dart';

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
          final revealedColors = isAnimatingRow ? animation.revealedColors : gameState.slotCount;
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
            protocol: gameState.protocol,
          );
        } else {
          final isActive = index == history.length &&
              gameState.status == GameStatus.playing &&
              !animation.isAnimating;
          final emptyRow = _buildEmptyRow(context, gameState, index, isActive);
          if (index >= 10) {
            return _AnimatedEmptyRow(child: emptyRow);
          } else {
            return emptyRow;
          }
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
    required int revealedColors,
    required SecurityProtocol protocol,
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
                          child: _buildFeedback(context, protocol, greenPegs, yellowPegs),
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

  Widget _buildEmptyRow(BuildContext context, GameState gameState, int index, bool isActive) {
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
                          children: List.generate(gameState.slotCount, (_) {
                            return const Padding(
                              padding: EdgeInsets.only(
                                left: DesignTokens.unit,
                                right: DesignTokens.unit,
                              ),
                              child: NeonOrb(size: 32, gameColor: GameColor.empty),
                            );
                          }),
                        ),
                        _buildFeedback(context, gameState.protocol, 0, 0, isEmptyRow: true),
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

  Widget _buildFeedback(BuildContext context, SecurityProtocol protocol, int greenPegs, int yellowPegs, {bool isEmptyRow = false}) {
    return FeedbackPegsWidget(
      protocol: protocol,
      greenPegs: greenPegs,
      yellowPegs: yellowPegs,
      isEmptyRow: isEmptyRow,
    );
  }
}

class _AnimatedEmptyRow extends StatefulWidget {
  final Widget child;
  const _AnimatedEmptyRow({required this.child});

  @override
  State<_AnimatedEmptyRow> createState() => _AnimatedEmptyRowState();
}

class _AnimatedEmptyRowState extends State<_AnimatedEmptyRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
