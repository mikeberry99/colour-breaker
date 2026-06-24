import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seed loaded. Level set to ${decoded.protocol.name}.'),
        backgroundColor: DesignTokens.surfaceContainerHighest,
      ),
    );
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
            controller: _controller,
            maxLength: 5,
            textCapitalization: TextCapitalization.characters,
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
