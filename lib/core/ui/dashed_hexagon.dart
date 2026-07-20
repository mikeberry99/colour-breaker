import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a dashed hexagon outline (flat-top) instead of a dashed circle.
///
/// The hexagon is inscribed in the available [size], with dashes distributed
/// evenly along the perimeter.
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

    // Build the hexagon path (flat-top).
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = (math.min(size.width, size.height) - strokeWidth) / 2;

    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        hexPath.moveTo(x, y);
      } else {
        hexPath.lineTo(x, y);
      }
    }
    hexPath.close();

    // Compute dash metrics from the path.
    final metrics = hexPath.computeMetrics().first;
    final totalLength = metrics.length;
    final segmentLength = totalLength / dashCount;
    final gapLength = segmentLength * gapRatio;
    final dashLength = segmentLength - gapLength;

    // Draw each dash.
    double distance = 0;
    for (int i = 0; i < dashCount; i++) {
      final dashPath = metrics.extractPath(distance, distance + dashLength);
      canvas.drawPath(dashPath, paint);
      distance += segmentLength;
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
