import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/analytics/analytics_helper.dart';
import '../providers/level_selection_provider.dart';
import '../widgets/level_option_card.dart';
import '../widgets/seed_entry_dialog.dart';
import '../widgets/help_dialog.dart';

class LevelSelectionScreen extends ConsumerWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProtocol = ref.watch(selectedProtocolProvider);
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsHelper.instance.trackPageVisit('level_selection');
    });

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: Stack(
        children: [
          // 1. Radial Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    Color(0xFF201F1F),
                    Color(0xFF131313),
                  ],
                ),
              ),
            ),
          ),

          // 2. Custom Scanline Overlay
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ScanlinePainter(),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Custom AppBar (with glass effect and blur)
                _buildAppBar(context),

                // Main scrollable content
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          DesignTokens.gutter,
                          32,
                          DesignTokens.gutter,
                          120, // Add spacing for bottom fixed bar
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            const SizedBox(height: 16),
                            Text(
                              'SYSTEM ACCESS',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontFamily: DesignTokens.headlineFont,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.02,
                                color: DesignTokens.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SELECT SECURITY PROTOCOL',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.8),
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Protocols cards Column
                            ...SecurityProtocol.values.map((protocol) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: DesignTokens.gutter),
                                child: LevelOptionCard(
                                  protocol: protocol,
                                  isSelected: selectedProtocol == protocol,
                                  onTap: () {
                                    ref.read(selectedProtocolProvider.notifier).setProtocol(protocol);
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Fixed Bottom Action Area (Glass bar with button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomAction(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xCC131313), // background with opacity
            border: Border(
              bottom: BorderSide(
                color: DesignTokens.outlineVariant,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.gutter,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CODE HACKER',
                        style: GoogleFonts.sora(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.05,
                          color: DesignTokens.primaryNeonCyan,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SeedEntryDialog(),
                          );
                        },
                        icon: const Icon(
                          Icons.vpn_key_outlined,
                          color: DesignTokens.onSurfaceVariant,
                        ),
                        tooltip: 'Enter Session Seed',
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const HelpDialog(),
                          );
                        },
                        icon: const Icon(
                          Icons.help_outline_rounded,
                          color: DesignTokens.onSurfaceVariant,
                        ),
                        tooltip: 'Help',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC131313), // background with opacity
            border: Border(
              top: BorderSide(
                color: DesignTokens.outlineVariant,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.gutter,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _EstablishConnectionButton(
                    onPressed: () {
                      context.go('/game');
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse('https://mikeberry.dev/');
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        debugPrint('Could not launch $url');
                      }
                    },
                    borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'created by mikeberry.dev',
                        style: GoogleFonts.jetBrainsMono(
                          color: DesignTokens.onSurfaceVariant,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EstablishConnectionButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _EstablishConnectionButton({required this.onPressed});

  @override
  State<_EstablishConnectionButton> createState() => _EstablishConnectionButtonState();
}

class _EstablishConnectionButtonState extends State<_EstablishConnectionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.2)
                : DesignTokens.primaryNeonCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
            border: Border.all(
              color: DesignTokens.primaryNeonCyan,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: DesignTokens.primaryNeonCyan.withValues(alpha: _isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 15 : 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ESTABLISH CONNECTION',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: DesignTokens.primaryNeonCyan,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: DesignTokens.primaryNeonCyan,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  const ScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    // Draw scanline rects every 4px
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
