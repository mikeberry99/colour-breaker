import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DesignTokens.background,
      primaryColor: DesignTokens.primaryNeonCyan,
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.primaryNeonCyan,
        surface: DesignTokens.surfaceContainer,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          color: Colors.white,
          height: 1.1,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.2,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.6,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }
}
