import 'dart:math' as math;
import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;
  final double gapRatio;

  const DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashCount = 16,
    this.gapRatio = 0.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final double totalAngle = 2 * math.pi;
    final double segmentAngle = totalAngle / dashCount;
    final double gapAngle = segmentAngle * gapRatio;
    final double dashAngle = segmentAngle - gapAngle;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * segmentAngle - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashCount != dashCount ||
        oldDelegate.gapRatio != gapRatio;
  }
}
