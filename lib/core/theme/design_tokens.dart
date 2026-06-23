import 'package:flutter/material.dart';

class DesignTokens {
  // Brand & Aesthetic
  static const Color background = Color(0xFF131313);
  static const Color boardSurface = Color(0xFF1E1E1E);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color primaryFixed = Color(0xFF7DF4FF);
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFB9CACB);
  static const Color outlineVariant = Color(0xFF3B494B);
  
  // Interaction & Feedback
  static const Color primaryNeonCyan = Color(0xFF00F0FF);
  static const Color primaryFixedDim = Color(0xFF00DBE9);
  static const Color feedbackGreen = Color(0xFF39FF14); // Perfect match
  static const Color feedbackYellow = Color(0xFFFFF01F); // Partial match
  static const Color outline = Color(0xFF333333);

  // 6 Game Palette Colors — extracted directly from Stitch HTML
  static const List<Color> gamePalette = [
    Color(0xFFFF3131), // Red
    Color(0xFF3182FF), // Blue
    Color(0xFF39FF14), // Green
    Color(0xFFFFF01F), // Yellow
    Color(0xFFB026FF), // Purple
    Color(0xFFFF9100), // Orange
  ];

  // Spacing (Base unit 8px)
  static const double unit = 8.0;
  static const double gutter = 16.0;
  static const double rowGap = 12.0;
  static const double marginDesktop = 40.0;
  static const double maxBoardWidth = 440.0;

  // Typography Settings
  static const String headlineFont = 'Sora';
  static const String bodyFont = 'Inter';
  static const String labelFont = 'JetBrains Mono';

  // Shapes
  static const double radiusDefault = 8.0; // 0.5rem base
  static const double radiusLg = 16.0; // Buttons
}
