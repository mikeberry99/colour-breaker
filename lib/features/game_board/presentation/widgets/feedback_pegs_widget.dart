import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../domain/entities/security_protocol.dart';
import 'feedback_explanation_dialog.dart';

class FeedbackPegsWidget extends StatelessWidget {
  final SecurityProtocol protocol;
  final int greenPegs;
  final int yellowPegs;
  final bool isEmptyRow;

  const FeedbackPegsWidget({
    super.key,
    required this.protocol,
    required this.greenPegs,
    required this.yellowPegs,
    this.isEmptyRow = false,
  });

  @override
  Widget build(BuildContext context) {
    final int pegCount = (protocol == SecurityProtocol.novice || protocol == SecurityProtocol.breacher) ? 4 : 5;
    final List<PegData> pegData = [];
    if (!isEmptyRow) {
      for (int i = 0; i < greenPegs; i++) {
        pegData.add(const PegData(DesignTokens.feedbackGreen, isGlow: true));
      }
      for (int i = 0; i < yellowPegs; i++) {
        pegData.add(const PegData(DesignTokens.feedbackYellow, isGlow: true));
      }
      for (int i = pegData.length; i < pegCount; i++) {
        pegData.add(PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    } else {
      for (int i = 0; i < pegCount; i++) {
        pegData.add(PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
      }
    }

    final child = pegCount == 4
        ? FeedbackSquare(pegs: pegData)
        : FeedbackRing(pegs: pegData);

    final isMobile = isMobileBrowser;
    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 4.0 : DesignTokens.gutter),
      child: FeedbackInteractiveContainer(
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.7),
            builder: (context) => const FeedbackExplanationDialog(),
          );
        },
        child: child,
      ),
    );
  }
}

class PegData {
  final Color color;
  final bool isGlow;
  const PegData(this.color, {required this.isGlow});
}

class FeedbackSquare extends StatelessWidget {
  final List<PegData> pegs;
  final double pegSize;

  const FeedbackSquare({
    super.key,
    required this.pegs,
  }) : pegSize = 10;

  @override
  Widget build(BuildContext context) {
    final List<PegData> displayPegs = List.from(pegs);
    while (displayPegs.length < 4) {
      displayPegs.add(PegData(Colors.white.withValues(alpha: 0.1), isGlow: false));
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

  Widget _buildPeg(PegData peg) {
    return PegWidget(peg: peg, size: pegSize);
  }
}

class FeedbackRing extends StatelessWidget {
  final List<PegData> pegs;
  final double radius;
  final double pegSize;

  const FeedbackRing({
    super.key,
    required this.pegs,
  }) : radius = 14, pegSize = 10;

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
            child: PegWidget(peg: peg, size: pegSize),
          );
        }),
      ),
    );
  }
}

class PegWidget extends StatelessWidget {
  final PegData peg;
  final double size;

  const PegWidget({
    super.key,
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
              painter: CenterDotPainter(),
            )
          : null,
    );
  }
}

class CenterDotPainter extends CustomPainter {
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

class FeedbackInteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const FeedbackInteractiveContainer({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<FeedbackInteractiveContainer> createState() => _FeedbackInteractiveContainerState();
}

class _FeedbackInteractiveContainerState extends State<FeedbackInteractiveContainer> {
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
