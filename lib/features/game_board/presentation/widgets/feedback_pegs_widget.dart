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

  final bool showHelpIndicator;

  const FeedbackPegsWidget({
    super.key,
    required this.protocol,
    required this.greenPegs,
    required this.yellowPegs,
    this.isEmptyRow = false,
    this.showHelpIndicator = false,
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

    final child = DesignTokens.useSegmentRingFeedback
        ? FeedbackSegmentRing(pegs: pegData)
        : (pegCount == 4
            ? FeedbackSquare(pegs: pegData)
            : FeedbackRing(pegs: pegData));

    final isMobile = isMobileBrowser;
    Widget content = FeedbackInteractiveContainer(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.7),
          builder: (context) => const FeedbackExplanationDialog(),
        );
      },
      child: child,
    );

    if (showHelpIndicator) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            right: -2,
            bottom: -2,
            child: IgnorePointer(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E262B),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignTokens.primaryNeonCyan,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      color: DesignTokens.primaryNeonCyan,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 4.0 : DesignTokens.gutter),
      child: content,
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

class FeedbackSegmentRing extends StatelessWidget {
  final List<PegData> pegs;
  final double size;

  const FeedbackSegmentRing({
    super.key,
    required this.pegs,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: SegmentRingPainter(pegs: pegs),
    );
  }
}

class SegmentRingPainter extends CustomPainter {
  final List<PegData> pegs;

  SegmentRingPainter({required this.pegs});

  @override
  void paint(Canvas canvas, Size size) {
    final int count = pegs.length;
    if (count == 0) return;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.38; // Inner hole
    final double sweepAngle = (2 * math.pi) / count;
    final double gapAngle = 0.05; // Gap between ring segments in radians (~2.8 deg)
    final double actualSweep = sweepAngle - gapAngle;

    for (int i = 0; i < count; i++) {
      final peg = pegs[i];
      final double startAngle = -math.pi / 2 + i * sweepAngle + (gapAngle / 2);
      final double midAngle = startAngle + actualSweep / 2;

      final Color segColor = peg.isGlow
          ? peg.color
          : Colors.white.withValues(alpha: 0.12);

      final Paint fillPaint = Paint()
        ..color = segColor
        ..style = PaintingStyle.fill;

      final Path path = Path();
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        actualSweep,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + actualSweep,
        -actualSweep,
        false,
      );
      path.close();

      // Subtle glow for active green/yellow segments
      if (peg.isGlow) {
        final Paint glowPaint = Paint()
          ..color = segColor.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
        canvas.drawPath(path, glowPaint);
      }

      canvas.drawPath(path, fillPaint);

      final Paint borderPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawPath(path, borderPaint);

      // Black dot indicator for yellow segments (same dot style as peg design)
      if (peg.color == DesignTokens.feedbackYellow && peg.isGlow) {
        final double midRadius = (outerRadius + innerRadius) / 2;
        final Offset dotCenter = Offset(
          center.dx + midRadius * math.cos(midAngle),
          center.dy + midRadius * math.sin(midAngle),
        );
        final Paint dotPaint = Paint()
          ..color = DesignTokens.background
          ..style = PaintingStyle.fill;
        canvas.drawCircle(dotCenter, 1.8, dotPaint);
      }
    }

    // Central dark hole
    final Paint holePaint = Paint()
      ..color = DesignTokens.background
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, holePaint);
  }

  @override
  bool shouldRepaint(covariant SegmentRingPainter oldDelegate) {
    return oldDelegate.pegs != pegs;
  }
}

