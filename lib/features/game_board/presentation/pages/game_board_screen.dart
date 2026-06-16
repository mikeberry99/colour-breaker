import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../widgets/header_widget.dart';
import '../widgets/history_log.dart';
import '../widgets/active_guess_row.dart';
import '../widgets/color_palette.dart';
import '../widgets/submit_button.dart';
import '../providers/game_provider.dart';

class GameBoardScreen extends StatelessWidget {
  const GameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: const _CustomSideDrawer(),
      ),
      // Fixed glass footer — matches Stitch <footer class="fixed bottom-0 glass-card border-t">
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0x08FFFFFF), // rgba(255,255,255,0.03)
              border: Border(
                top: BorderSide(color: Color(0xFF3B494B), width: 1),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Center(
              heightFactor: 1.0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActiveGuessRow(),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ColorPalette(),
                        SizedBox(width: 12),
                        Expanded(child: SubmitButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
                child: const Column(
                  children: [
                    HeaderWidget(),
                    SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
                        child: Column(
                          children: [
                            HistoryLog(),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E0E0E).withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3B494B).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: DesignTokens.primaryNeonCyan,
                        size: 24,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Open Terminal Menu',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSideDrawer extends ConsumerWidget {
  const _CustomSideDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xD90E0E0E),
              border: Border(
                right: BorderSide(
                  color: DesignTokens.primaryNeonCyan,
                  width: 2,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 40, 24, 20),
                    child: Text(
                      'TERMINAL',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.primaryNeonCyan,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF3B494B), height: 1),
                  const SizedBox(height: 20),
                  _DrawerItem(
                    icon: Icons.play_arrow_rounded,
                    label: 'New Game',
                    onTap: () {
                      ref.read(gameStateProvider.notifier).restartGame();
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.refresh_rounded,
                    label: 'Restart Level',
                    onTap: () {
                      ref.read(gameStateProvider.notifier).restartLevel();
                      Navigator.pop(context);
                    },
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: DesignTokens.primaryNeonCyan,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
