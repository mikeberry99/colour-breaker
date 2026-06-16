import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';

enum GameColor {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
  empty
}

/// Geometric shapes rendered inside each colour orb.
enum OrbShape {
  triangle,
  square,
  heart,
  star,
  plus,
  diamond,
  none,
}

extension GameColorExtension on GameColor {
  Color get uiColor {
    switch (this) {
      case GameColor.red:
        return DesignTokens.gamePalette[0];
      case GameColor.blue:
        return DesignTokens.gamePalette[1];
      case GameColor.green:
        return DesignTokens.gamePalette[2];
      case GameColor.yellow:
        return DesignTokens.gamePalette[3];
      case GameColor.purple:
        return DesignTokens.gamePalette[4];
      case GameColor.orange:
        return DesignTokens.gamePalette[5];
      case GameColor.empty:
        return Colors.transparent;
    }
  }

  OrbShape get orbShape {
    switch (this) {
      case GameColor.red:
        return OrbShape.triangle;   // Red = Triangle
      case GameColor.blue:
        return OrbShape.square;     // Blue = Square
      case GameColor.green:
        return OrbShape.heart;      // Green = Heart
      case GameColor.yellow:
        return OrbShape.star;       // Yellow = Star
      case GameColor.purple:
        return OrbShape.plus;       // Purple = Plus
      case GameColor.orange:
        return OrbShape.diamond;    // Orange = Diamond
      case GameColor.empty:
        return OrbShape.none;
    }
  }
}

