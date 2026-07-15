import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import 'package:hex_breaker/features/game_board/domain/entities/game_color.dart';

class NeonOrb extends StatelessWidget {
  final GameColor? gameColor;
  final Color? color;
  final double size;
  final bool isSelected;
  final bool isEmpty;

  const NeonOrb({
    super.key,
    this.gameColor,
    this.color,
    this.size = 40.0,
    this.isSelected = false,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsEmpty = isEmpty || (gameColor == GameColor.empty);
    final effectiveColor = color ?? gameColor?.uiColor;

    if (effectiveIsEmpty || effectiveColor == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [DesignTokens.boardSurface, DesignTokens.surfaceContainerHigh],
            center: Alignment.center,
            radius: 0.8,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      );
    }

    final shape = gameColor?.orbShape ?? OrbShape.none;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveColor,
        border: isSelected
            ? Border.all(color: Colors.white, width: 2.0)
            : Border.all(color: Colors.transparent, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: isSelected ? 4 : 2,
          ),
        ],
      ),
      child: shape != OrbShape.none
          ? Center(
              child: CustomPaint(
                size: Size(size * 0.48, size * 0.48),
                painter: _ShapePainter(shape: shape),
              ),
            )
          : null,
    );
  }
}

/// Paints a filled black geometric shape inside the orb.
class _ShapePainter extends CustomPainter {
  final OrbShape shape;

  const _ShapePainter({required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    switch (shape) {
      case OrbShape.triangle:
        _drawTriangle(canvas, size, paint);
        break;
      case OrbShape.square:
        _drawSquare(canvas, size, paint);
        break;
      case OrbShape.heart:
        _drawHeart(canvas, size, paint);
        break;
      case OrbShape.star:
        _drawStar(canvas, size, paint);
        break;
      case OrbShape.plus:
        _drawPlus(canvas, size, paint);
        break;
      case OrbShape.diamond:
        _drawDiamond(canvas, size, paint);
        break;
      case OrbShape.none:
        break;
    }
  }

  void _drawTriangle(Canvas canvas, Size size, Paint paint) {
    final path = Path()
      ..moveTo(size.width / 2, 1)
      ..lineTo(size.width - 1, size.height - 1)
      ..lineTo(1, size.height - 1)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawSquare(Canvas canvas, Size size, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), paint);
  }

  void _drawHeart(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    // Start at top center cleft
    path.moveTo(w / 2, h * 0.25);
    // Left lobe
    path.cubicTo(w * 0.3, h * 0.05, 0, h * 0.2, 0, h * 0.45);
    // Curve down to bottom tip
    path.cubicTo(0, h * 0.7, w * 0.35, h * 0.9, w / 2, h * 0.95);
    // Curve up from bottom tip to right side
    path.cubicTo(w * 0.65, h * 0.9, w, h * 0.7, w, h * 0.45);
    // Right lobe back to cleft
    path.cubicTo(w, h * 0.2, w * 0.7, h * 0.05, w / 2, h * 0.25);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Size size, Paint paint) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.4;
    const points = 5;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawPlus(Canvas canvas, Size size, Paint paint) {
    final t = size.width * 0.28;
    // Horizontal bar
    canvas.drawRect(
      Rect.fromLTWH(0, (size.height - t) / 2, size.width, t),
      paint,
    );
    // Vertical bar
    canvas.drawRect(
      Rect.fromLTWH((size.width - t) / 2, 0, t, size.height),
      paint,
    );
  }

  void _drawDiamond(Canvas canvas, Size size, Paint paint) {
    final path = Path()
      ..moveTo(size.width / 2, 1)
      ..lineTo(size.width - 1, size.height / 2)
      ..lineTo(size.width / 2, size.height - 1)
      ..lineTo(1, size.height / 2)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) => oldDelegate.shape != shape;
}
