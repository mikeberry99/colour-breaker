import 'dart:math' as math;
import 'package:flutter/rendering.dart';

/// Returns a flat-top hexagon [Path] centered in the given [size].
///
/// The hexagon is inscribed in the rectangle so that the flat edges are at
/// the top and bottom.
Path hexagonPath(Size size) {
  final cx = size.width / 2;
  final cy = size.height / 2;
  final r = math.min(cx, cy);
  final path = Path();
  for (int i = 0; i < 6; i++) {
    // Start at -30° so the first vertex is top-right → flat top & bottom.
    final angle = (math.pi / 3) * i - math.pi / 6;
    final x = cx + r * math.cos(angle);
    final y = cy + r * math.sin(angle);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

/// A [CustomClipper] that clips its child to a flat-top hexagon.
class HexagonClipper extends CustomClipper<Path> {
  const HexagonClipper();

  @override
  Path getClip(Size size) => hexagonPath(size);

  @override
  bool shouldReclip(covariant HexagonClipper oldClipper) => false;
}
