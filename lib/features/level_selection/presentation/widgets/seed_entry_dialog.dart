import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../game_board/domain/entities/game_seed.dart';
import '../providers/level_selection_provider.dart';

class SeedEntryDialog extends ConsumerStatefulWidget {
  const SeedEntryDialog({super.key});

  @override
  ConsumerState<SeedEntryDialog> createState() => _SeedEntryDialogState();
}

class _SeedEntryDialogState extends ConsumerState<SeedEntryDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final seed = _controller.text.trim().toUpperCase();
    if (seed.isEmpty) {
      setState(() => _errorMessage = 'Please enter a seed');
      return;
    }

    final decoded = GameSeed.decode(seed);
    if (decoded == null) {
      setState(() => _errorMessage = 'Invalid Session Seed');
      return;
    }

    // Valid seed!
    ref.read(sessionSeedProvider.notifier).setSeed(decoded);
    ref.read(selectedProtocolProvider.notifier).setProtocol(decoded.protocol);
    
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    Navigator.of(context).pop();
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          'Seed loaded. Level set to ${decoded.protocol.name}.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: DesignTokens.surfaceContainerHighest,
      ),
    );

    router.go('/game');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignTokens.boardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
        side: const BorderSide(color: DesignTokens.outlineVariant, width: 1),
      ),
      title: Text(
        'ENTER SESSION SEED',
        style: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: DesignTokens.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input a 5-letter seed to replay a specific game state.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: DesignTokens.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            autofocus: true,
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              SeedPasteFormatter(),
            ],
            style: GoogleFonts.jetBrainsMono(
              color: DesignTokens.primaryNeonCyan,
              fontSize: 24,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'ABCDE',
              hintStyle: GoogleFonts.jetBrainsMono(
                color: DesignTokens.onSurfaceVariant.withValues(alpha: 0.3),
                fontSize: 24,
                letterSpacing: 4.0,
              ),
              filled: true,
              fillColor: DesignTokens.background,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: DesignTokens.outlineVariant),
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: DesignTokens.primaryNeonCyan, width: 2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
              ),
              errorText: _errorMessage,
              errorStyle: GoogleFonts.inter(
                color: DesignTokens.gamePalette[0], // Red
              ),
            ),
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() => _errorMessage = null);
              }
            },
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: GoogleFonts.jetBrainsMono(
              color: DesignTokens.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignTokens.primaryNeonCyan.withValues(alpha: 0.1),
            foregroundColor: DesignTokens.primaryNeonCyan,
            side: const BorderSide(color: DesignTokens.primaryNeonCyan),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
            ),
          ),
          onPressed: _submit,
          child: Text(
            'LOAD SEED',
            style: GoogleFonts.jetBrainsMono(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class SeedPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Check if the input contains a share message pattern.
    // The pattern is: "Seed: <5 letters>"
    final seedRegex = RegExp(r'[Ss]eed:\s*([A-Za-z]{5})\b');
    final match = seedRegex.firstMatch(text);
    if (match != null) {
      final extracted = match.group(1)!.toUpperCase();
      return TextEditingValue(
        text: extracted,
        selection: TextSelection.collapsed(offset: extracted.length),
      );
    }
    
    // Check fallback for any 5-letter word that decodes as a valid seed,
    // if the text contains keywords of the share message.
    if (text.contains('I cracked') || text.contains('Code Hacker') || text.contains('HEX_BREAKER') || text.contains('tough this time')) {
      final words = text.split(RegExp(r'[\s!,.\?]+'));
      for (final word in words) {
        if (word.length == 5) {
          final uppercaseWord = word.toUpperCase();
          if (GameSeed.decode(uppercaseWord) != null) {
            return TextEditingValue(
              text: uppercaseWord,
              selection: TextSelection.collapsed(offset: uppercaseWord.length),
            );
          }
        }
      }
    }
    
    // Otherwise, limit the text to 5 characters and convert to uppercase.
    String uppercaseText = text.toUpperCase();
    if (uppercaseText.length > 5) {
      uppercaseText = uppercaseText.substring(0, 5);
    }
    
    // Adjust cursor position if it exceeds the new length
    int selectionOffset = newValue.selection.end;
    if (selectionOffset < 0 || selectionOffset > uppercaseText.length) {
      selectionOffset = uppercaseText.length;
    }
    
    return TextEditingValue(
      text: uppercaseText,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}
