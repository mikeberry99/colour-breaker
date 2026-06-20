import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/ui/neon_orb.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/reveal_animation_provider.dart';
import '../../../level_selection/presentation/providers/level_selection_provider.dart';
import 'security_protocol_dialog.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final notifier = ref.read(gameStateProvider.notifier);
    final animation = ref.watch(revealAnimationProvider);
    final protocol = ref.watch(selectedProtocolProvider);
    final isGameOver =
        gameState.status != GameStatus.playing && !animation.isAnimating;
    final revealedSolution = isGameOver ? notifier.revealedSolution : null;
    final slotCount = gameState.slotCount;

    return Column(
      children: [
        const SizedBox(height: 16),
        // Hidden Solution Container — matches Stitch HUD Integration Prototype
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: DesignTokens.gutter),
          child: _HeaderInteractiveContainer(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withValues(alpha: 0.7),
                builder: (context) => SecurityProtocolDialog(protocol: protocol),
              );
            },
            child: Stack(
              children: [
                // Protocol label — top-left, 50% opacity
                Positioned(
                  top: 8,
                  left: 12,
                  child: Opacity(
                    opacity: 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.security,
                          color: DesignTokens.primaryNeonCyan,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Protocol: ${protocol.title}',
                          style: const TextStyle(
                            fontFamily: DesignTokens.labelFont,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: DesignTokens.primaryNeonCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Solution orb slots
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(slotCount, (index) {
                        final isRevealed = revealedSolution != null;
                        final color = isRevealed
                            ? revealedSolution.colors[index]
                            : null;

                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedSwitcher(
                            duration:
                                const Duration(milliseconds: 300),
                            child: isRevealed
                                ? NeonOrb(
                                    key: ValueKey(
                                        'revealed-$index-${color?.name}'),
                                    size: 40,
                                    gameColor: color,
                                  )
                                : _LockedSlot(
                                    key: const ValueKey('locked'),
                                    size: 40,
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Static game over text removed in favor of GameResultOverlay
      ],
    );
  }
}

class _HeaderInteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HeaderInteractiveContainer({
    required this.child,
    required this.onTap,
  });

  @override
  State<_HeaderInteractiveContainer> createState() => _HeaderInteractiveContainerState();
}

class _HeaderInteractiveContainerState extends State<_HeaderInteractiveContainer> {
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
          decoration: BoxDecoration(
            color: _isHovered
                ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.05)
                : DesignTokens.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? DesignTokens.primaryNeonCyan
                  : DesignTokens.primaryNeonCyan.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.35)
                    : DesignTokens.primaryNeonCyan.withValues(alpha: 0.15),
                blurRadius: _isHovered ? 20 : 15,
                spreadRadius: 0,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A recessed circular slot with a lock icon — matches the Stitch
/// `.recessed-slot` style with a filled Material `lock` symbol.
class _LockedSlot extends StatelessWidget {
  final double size;

  const _LockedSlot({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            DesignTokens.surfaceContainerHigh, // #2A2A2A
            DesignTokens.boardSurface, // #1E1E1E
          ],
          center: Alignment.center,
          radius: 0.8,
        ),
        border: Border.all(
          color: DesignTokens.outlineVariant, // #3B494B
          width: 0.5,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock,
          color: DesignTokens.primaryNeonCyan,
          size: size * 0.45,
        ),
      ),
    );
  }
}
