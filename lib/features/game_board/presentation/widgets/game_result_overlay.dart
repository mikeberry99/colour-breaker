import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/hexagon_clipper.dart';
import '../../../../core/utils/platform_utils.dart';
import '../../domain/entities/game_state.dart';

class GameResultOverlay extends StatelessWidget {
  final GameState gameState;
  final String sessionSeed;
  final VoidCallback onClose;
  final VoidCallback onNewGame;

  const GameResultOverlay({
    super.key,
    required this.gameState,
    required this.sessionSeed,
    required this.onClose,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    final isWin = gameState.status == GameStatus.won;
    final color = isWin ? DesignTokens.feedbackGreen : DesignTokens.feedbackYellow;
    final attempts = gameState.history.length;
    final isMobile = isMobileBrowser;
    
    // Alert text
    final alertIcon = isWin ? Icons.priority_high : Icons.warning_amber_rounded;
    final alertText = isWin ? 'Alert: Success' : 'Alert: Failed';
    final headerText = isWin ? 'System Breached' : 'Access Denied';
    final subtitleText = isWin ? 'ENCRYPTION BYPASSED' : 'SYSTEM LOCKED';
    final quoteText = gameState.selectedQuote ??
        (isWin ? 'Sequence decrypted successfully. Well done!' : 'Mission failed. Try again.');

    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              decoration: BoxDecoration(
                color: DesignTokens.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Alert Tag & Close Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              alertIcon,
                              color: color,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              alertText.toUpperCase(),
                              style: TextStyle(
                                fontFamily: DesignTokens.labelFont,
                                fontSize: isMobile ? 10 : 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onClose,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: DesignTokens.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: isMobile ? 8 : 16),
                    
                    // Header
                    Column(
                      children: [
                        Text(
                          headerText.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: DesignTokens.headlineFont,
                            fontSize: isMobile ? 28 : 42, 
                            height: 1.0,
                            fontWeight: FontWeight.w800,
                            color: color,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: isMobile ? 4 : 8),
                        Text(
                          subtitleText,
                          style: TextStyle(
                            fontFamily: DesignTokens.labelFont,
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.onSurfaceVariant,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: isMobile ? 16 : 32),
                    
                    // Stats — hexagon container
                    Center(
                      child: SizedBox(
                        width: isMobile ? 130 : 170,
                        height: isMobile ? 130 : 170,
                        child: CustomPaint(
                          painter: _HexStatsPainter(
                            fillColor: DesignTokens.surfaceContainerLow,
                            borderColor: DesignTokens.outlineVariant.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ATTEMPTS',
                                  style: TextStyle(
                                    fontFamily: DesignTokens.labelFont,
                                    fontSize: isMobile ? 10 : 12,
                                    fontWeight: FontWeight.bold,
                                    color: DesignTokens.onSurfaceVariant,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  attempts.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontFamily: DesignTokens.headlineFont,
                                    fontSize: isMobile ? 48 : 64,
                                    height: 1.0,
                                    fontWeight: FontWeight.w800,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 16 : 32),
                    
                    // Quote
                    Text(
                      '"$quoteText"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: DesignTokens.bodyFont,
                        fontSize: isMobile ? 12 : 14,
                        fontStyle: FontStyle.italic,
                        color: DesignTokens.onSurfaceVariant,
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 16 : 32),
                    
                    // Share Section
                    if (sessionSeed.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isMobile ? 8 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: DesignTokens.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: DesignTokens.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SESSION SEED',
                                    style: TextStyle(
                                      fontFamily: DesignTokens.labelFont,
                                      fontSize: isMobile ? 8 : 10,
                                      fontWeight: FontWeight.bold,
                                      color: DesignTokens.onSurfaceVariant,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    sessionSeed,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: DesignTokens.labelFont,
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: DesignTokens.primaryNeonCyan,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _ShareButton(
                              seed: sessionSeed,
                              attempts: attempts,
                              isWin: isWin,
                            ),
                          ],
                        ),
                      ),
                      
                    if (sessionSeed.isNotEmpty)
                      SizedBox(height: isMobile ? 16 : 32),
                    
                    // CTA
                    _NewGameButton(
                      color: color,
                      onTap: onNewGame,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatefulWidget {
  final String seed;
  final int attempts;
  final bool isWin;
  
  const _ShareButton({
    required this.seed,
    required this.attempts,
    required this.isWin,
  });

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _isHovered = false;

  void _handleShare() {
    final String text = widget.isWin 
      ? 'I cracked the HEX_BREAKER sequence in ${widget.attempts} attempts! Seed: ${widget.seed}. Can you beat my score?'
      : 'HEX_BREAKER proved too tough this time. Seed: ${widget.seed}. Give it a try!';
      
    Clipboard.setData(ClipboardData(text: text));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Seed copied to clipboard!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: DesignTokens.surfaceContainerHigh,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleShare,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.share,
                size: 20,
                color: _isHovered ? DesignTokens.primaryNeonCyan : DesignTokens.primaryNeonCyan.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Text(
                'SHARE',
                style: TextStyle(
                  fontFamily: DesignTokens.labelFont,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? DesignTokens.primaryNeonCyan : DesignTokens.primaryNeonCyan.withValues(alpha: 0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewGameButton extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;

  const _NewGameButton({
    required this.color,
    required this.onTap,
  });

  @override
  State<_NewGameButton> createState() => _NewGameButtonState();
}

class _NewGameButtonState extends State<_NewGameButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isMobileBrowser ? 12 : 20),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.2)
                : widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Text(
            'PLAY AGAIN?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: DesignTokens.labelFont,
              fontSize: isMobileBrowser ? 14 : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _HexStatsPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  const _HexStatsPainter({required this.fillColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = hexagonPath(size);

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_HexStatsPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor || oldDelegate.borderColor != borderColor;
}
