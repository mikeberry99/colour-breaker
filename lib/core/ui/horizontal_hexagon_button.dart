import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Calculates the 6 vertices of an horizontal elongated hexagon path with
/// pointed left and right ends.
///
/// Insets by [borderWidth] / 2 so that stroke paints inside the [size] boundary.
Path horizontalHexagonPath(
  Size size, {
  double cutWidthRatio = 0.25,
  double borderWidth = 0.0,
}) {
  final inset = borderWidth / 2;
  final w = size.width - borderWidth;
  final h = size.height - borderWidth;
  if (w <= 0 || h <= 0) return Path();

  final cut = math.min(h * cutWidthRatio, w * 0.25);

  final path = Path()
    ..moveTo(inset + cut, inset)
    ..lineTo(inset + w - cut, inset)
    ..lineTo(inset + w, inset + h / 2)
    ..lineTo(inset + w - cut, inset + h)
    ..lineTo(inset + cut, inset + h)
    ..lineTo(inset, inset + h / 2)
    ..close();

  return path;
}

/// Clipper that clips to a horizontal elongated hexagon path.
class HorizontalHexagonClipper extends CustomClipper<Path> {
  final double cutWidthRatio;

  const HorizontalHexagonClipper({this.cutWidthRatio = 0.25});

  @override
  Path getClip(Size size) => horizontalHexagonPath(size, cutWidthRatio: cutWidthRatio);

  @override
  bool shouldReclip(covariant HorizontalHexagonClipper oldClipper) =>
      oldClipper.cutWidthRatio != cutWidthRatio;
}

/// Custom painter for horizontal hexagon shape with background fill,
/// border outline, and glowing shadow.
class HorizontalHexagonPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final Color? glowColor;
  final double glowBlurRadius;
  final double cutWidthRatio;

  const HorizontalHexagonPainter({
    required this.fillColor,
    required this.borderColor,
    this.borderWidth = 2.0,
    this.glowColor,
    this.glowBlurRadius = 15.0,
    this.cutWidthRatio = 0.25,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = horizontalHexagonPath(
      size,
      cutWidthRatio: cutWidthRatio,
      borderWidth: borderWidth,
    );

    // Glow shadow
    if (glowColor != null && glowColor!.a > 0 && glowBlurRadius > 0) {
      final glowStrokePaint = Paint()
        ..color = glowColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth + 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlurRadius);
      canvas.drawPath(path, glowStrokePaint);

      final glowFillPaint = Paint()
        ..color = glowColor!.withValues(alpha: glowColor!.a * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlurRadius);
      canvas.drawPath(path, glowFillPaint);
    }

    // Fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Border
    if (borderWidth > 0 && borderColor.a > 0) {
      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeJoin = StrokeJoin.miter;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HorizontalHexagonPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.glowBlurRadius != glowBlurRadius ||
        oldDelegate.cutWidthRatio != cutWidthRatio;
  }
}

/// Interactive horizontal hexagon button widget with hover glow and custom styling.
class HorizontalHexagonButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color fillColor;
  final Color borderColor;
  final Color? glowColor;
  final double borderWidth;
  final double glowBlurRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final double cutWidthRatio;
  final bool isEnabled;

  const HorizontalHexagonButton({
    super.key,
    required this.child,
    this.onTap,
    required this.fillColor,
    required this.borderColor,
    this.glowColor,
    this.borderWidth = 2.0,
    this.glowBlurRadius = 15.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.width,
    this.height,
    this.cutWidthRatio = 0.25,
    this.isEnabled = true,
  });

  @override
  State<HorizontalHexagonButton> createState() => _HorizontalHexagonButtonState();
}

class _HorizontalHexagonButtonState extends State<HorizontalHexagonButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final canClick = widget.isEnabled && widget.onTap != null;
    final cursor = canClick ? SystemMouseCursors.click : SystemMouseCursors.basic;

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) {
        if (canClick) setState(() => _isHovered = true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: canClick ? widget.onTap : null,
        child: TweenAnimationBuilder<Color?>(
          duration: const Duration(milliseconds: 150),
          tween: ColorTween(end: widget.fillColor),
          builder: (context, animatedFill, _) {
            return TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 150),
              tween: ColorTween(end: widget.borderColor),
              builder: (context, animatedBorder, _) {
                return CustomPaint(
                  painter: HorizontalHexagonPainter(
                    fillColor: animatedFill ?? widget.fillColor,
                    borderColor: animatedBorder ?? widget.borderColor,
                    borderWidth: widget.borderWidth,
                    glowColor: _isHovered ? widget.glowColor : widget.glowColor?.withValues(alpha: 0.5),
                    glowBlurRadius: _isHovered ? widget.glowBlurRadius * 1.3 : widget.glowBlurRadius,
                    cutWidthRatio: widget.cutWidthRatio,
                  ),
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    padding: widget.padding,
                    alignment: Alignment.center,
                    child: widget.child,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
