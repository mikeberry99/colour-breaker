import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/utils/platform_utils.dart';
import '../widgets/header_widget.dart';
import '../widgets/history_log.dart';
import '../widgets/active_guess_row.dart';
import '../widgets/color_palette.dart';
import '../widgets/submit_button.dart';
import '../providers/game_provider.dart';
import '../widgets/guess_counter_badge.dart';
import '../widgets/game_result_overlay.dart';
import '../providers/reveal_animation_provider.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/game_seed.dart';

class OverlayDismissedNotifier extends Notifier<bool> {
  @override
  bool build() {
    final status = ref.watch(gameStateProvider.select((s) => s.status));
    if (status == GameStatus.playing) {
      return false;
    }
    return false;
  }

  void dismiss() {
    state = true;
  }
}

final overlayDismissedProvider =
    NotifierProvider.autoDispose<OverlayDismissedNotifier, bool>(
  OverlayDismissedNotifier.new,
);

class GameBoardScreen extends ConsumerStatefulWidget {
  const GameBoardScreen({super.key});

  @override
  ConsumerState<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends ConsumerState<GameBoardScreen> {
  final GlobalKey _activeRowKey = GlobalKey();
  final GlobalKey _scrollViewKey = GlobalKey();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            vertical: 12,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
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
                  Text(
                    'HEX_BREAKER',
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.05,
                      color: DesignTokens.primaryNeonCyan,
                    ),
                  ),
                  const GuessCounterBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RevealAnimationState>(revealAnimationProvider, (previous, next) {
      if (previous?.isAnimating == true && next.isAnimating == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = _activeRowKey.currentContext;
          final scrollCtx = _scrollViewKey.currentContext;
          if (ctx != null && ctx.mounted && scrollCtx != null && scrollCtx.mounted) {
            final RenderBox? renderBox = ctx.findRenderObject() as RenderBox?;
            final RenderBox? scrollRenderBox = scrollCtx.findRenderObject() as RenderBox?;
            if (renderBox != null && scrollRenderBox != null && _scrollController.hasClients) {
              final Offset position = renderBox.localToGlobal(Offset.zero, ancestor: scrollRenderBox);
              final double widgetTop = position.dy;
              final double widgetBottom = widgetTop + renderBox.size.height;
              final double viewportHeight = _scrollController.position.viewportDimension;

              final bool isVisible = widgetTop >= 0 && widgetBottom <= viewportHeight;
              if (!isVisible) {
                _scrollController.position.ensureVisible(
                  renderBox,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          }
        });
      }
    });

    final gameState = ref.watch(gameStateProvider);
    final animation = ref.watch(revealAnimationProvider);
    final isGameOver = gameState.status != GameStatus.playing && !animation.isAnimating;
    final isDismissed = ref.watch(overlayDismissedProvider);

    final isMobile = isMobileBrowser;

    return Title(
      title: 'Hex_Breaker - Game',
      color: DesignTokens.primaryNeonCyan,
      child: Scaffold(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isMobile) ...[
                        if (gameState.history.isEmpty) ...[
                          Text(
                            'Select a combination of coloured tiles to guess the hidden sequence.\nThe feedback on the right shows how many colours are correct.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: DesignTokens.labelFont,
                              fontSize: 13,
                              height: 1.3,
                              color: DesignTokens.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ActiveGuessRow(),
                            SizedBox(width: 8),
                            SubmitButton(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Center(child: ColorPalette()),
                      ] else ...[
                        if (gameState.history.isEmpty) ...[
                          Text(
                            'Select a combination of coloured tiles to guess the hidden sequence.\nThe feedback on the right shows how many colours are correct.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: DesignTokens.labelFont,
                              fontSize: 11,
                              height: 1.3,
                              color: DesignTokens.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        const ActiveGuessRow(),
                        const SizedBox(height: 8),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ColorPalette(),
                            SizedBox(width: 12),
                            Expanded(child: SubmitButton()),
                          ],
                        ),
                      ],
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
              Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
                        child: Column(
                          children: [
                            const HeaderWidget(),
                            const SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                key: _scrollViewKey,
                                controller: _scrollController,
                                reverse: true,
                                padding: const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
                                child: Column(
                                  children: [
                                    HistoryLog(activeRowKey: _activeRowKey),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isGameOver && !isDismissed)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: DesignTokens.maxBoardWidth),
                        child: Builder(
                          builder: (context) {
                            final solution = ref.read(gameStateProvider.notifier).revealedSolution;
                            final seed = solution != null ? GameSeed.encode(gameState.protocol, solution.colors) : '';
                            return GameResultOverlay(
                              gameState: gameState,
                              sessionSeed: seed,
                              onClose: () {
                                ref.read(overlayDismissedProvider.notifier).dismiss();
                              },
                              onNewGame: () {
                                ref.read(gameStateProvider.notifier).restartGame();
                                context.go('/');
                              },
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
                        fontFamily: DesignTokens.labelFont,
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
                      context.go('/');
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
                fontFamily: DesignTokens.labelFont,
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
