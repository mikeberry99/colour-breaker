import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_color.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/security_protocol.dart';
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
    final int pegCount = (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) ? 4 : 5;
    final List<_PegData> pegData = [];
    if (!isEmptyRow) {
      for (int i = 0; i < greenPegs; i++) {
        pegData.add(_PegData(DesignTokens.feedbackGreen, isGlow: true));
      }
      for (int i = 0; i < yellowPegs; i++) {
        pegData.add(_PegData(DesignTokens.feedbackYellow, isGlow: true));
      }
      for (int i = pegData.length; i < pegCount; i++) {
        pegData.add(_PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    } else {
      for (int i = 0; i < pegCount; i++) {
        pegData.add(_PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    }

    final child = pegCount == 4
        ? _FeedbackSquare(pegs: pegData)
        : _FeedbackRing(pegs: pegData);

    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.gutter),
      child: _FeedbackInteractiveContainer(
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.7),
            builder: (context) => const _FeedbackExplanationDialog(),
          );
        },
        child: child,
      ),
    );
  }
}

// --- Supporting types ---

class _PegData {
  final Color color;
  final bool isGlow;
  const _PegData(this.color, {required this.isGlow});
}

class _FeedbackSquare extends StatelessWidget {
  final List<_PegData> pegs;
  final double pegSize;

  const _FeedbackSquare({
    required this.pegs,
  }) : pegSize = 10;

  @override
  Widget build(BuildContext context) {
    final List<_PegData> displayPegs = List.from(pegs);
    while (displayPegs.length < 4) {
      displayPegs.add(_PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
    }

    return SizedBox(
      width: 42,
      height: 42,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPeg(displayPegs[0]),
              const SizedBox(width: 6),
              _buildPeg(displayPegs[1]),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPeg(displayPegs[2]),
              const SizedBox(width: 6),
              _buildPeg(displayPegs[3]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeg(_PegData peg) {
    return _PegWidget(peg: peg, size: pegSize);
  }
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
          final double angle = (2 * math.pi / count) * i - math.pi / 2;
          final double dx = radius * math.cos(angle);
          final double dy = radius * math.sin(angle);
          final peg = pegs[i];

          return Transform.translate(
            offset: Offset(dx, dy),
            child: _PegWidget(peg: peg, size: pegSize),
          );
        }),
      ),
    );
  }
}

class _PegWidget extends StatelessWidget {
  final _PegData peg;
  final double size;

  const _PegWidget({
    required this.peg,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isYellow = peg.color == DesignTokens.feedbackYellow;
    return Container(
      width: size,
      height: size,
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
      child: isYellow
          ? CustomPaint(
              size: Size(size, size),
              painter: _CenterDotPainter(),
            )
          : null,
    );
  }
}

class _CenterDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignTokens.background
      ..style = PaintingStyle.fill;

    // Draw a small dot at the center of the 10px peg
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      1.5,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class _FeedbackInteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _FeedbackInteractiveContainer({
    required this.child,
    required this.onTap,
  });

  @override
  State<_FeedbackInteractiveContainer> createState() => _FeedbackInteractiveContainerState();
}

class _FeedbackInteractiveContainerState extends State<_FeedbackInteractiveContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _isHovered
                ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
            border: Border.all(
              color: _isHovered
                  ? DesignTokens.primaryNeonCyan
                  : DesignTokens.primaryNeonCyan.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.25),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

class _FeedbackExplanationDialog extends StatelessWidget {
  const _FeedbackExplanationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: DesignTokens.background,
          borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
          border: Border.all(
            color: DesignTokens.primaryNeonCyan,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SEQUENCE FEEDBACK',
                    style: TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.primaryNeonCyan,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 1,
                color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _PegWidget(
                    peg: _PegData(DesignTokens.feedbackGreen, isGlow: true),
                    size: 10,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Green = Correct colour, correct location',
                      style: TextStyle(
                        fontFamily: DesignTokens.bodyFont,
                        fontSize: 13,
                        color: DesignTokens.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _PegWidget(
                    peg: _PegData(DesignTokens.feedbackYellow, isGlow: true),
                    size: 10,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Yellow = Correct colour, wrong location',
                      style: TextStyle(
                        fontFamily: DesignTokens.bodyFont,
                        fontSize: 13,
                        color: DesignTokens.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: DesignTokens.primaryNeonCyan,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                      side: BorderSide(
                        color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
