import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/design_tokens.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignTokens.boardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
        side: const BorderSide(color: DesignTokens.outlineVariant, width: 1),
      ),
      title: Text(
        'HELP PROTOCOL',
        style: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: DesignTokens.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Security Level',
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DesignTokens.primaryNeonCyan,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '1. Choose a difficulty level.\n'
              '2. Tap "ESTABLISH CONNECTION" to start the game.\n\n'
              'Novice Decryption, is the easiest and recommended for first time players.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: DesignTokens.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'How to Play',
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DesignTokens.primaryNeonCyan,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your objective is to crack the hidden color code sequence.\n\n'
              '1. Tap the color selector to fill the empty sequence with your guess.\n'
              '2. Submit your guess to receive feedback orbs from the system.\n'
              '3. A green orb means one of the colors is correct and in the right position.\n'
              '4. A yellow orb with a dot means a color is correct but in the wrong position.\n'
              '5. Crack the code before you run out of attempts to win!',
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: DesignTokens.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                DesignTokens.primaryNeonCyan.withValues(alpha: 0.1),
            foregroundColor: DesignTokens.primaryNeonCyan,
            side: const BorderSide(color: DesignTokens.primaryNeonCyan),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CLOSE',
            style: GoogleFonts.jetBrainsMono(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
