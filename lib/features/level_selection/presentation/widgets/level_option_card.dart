import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import '../providers/level_selection_provider.dart';

class LevelOptionCard extends StatefulWidget {
  final SecurityProtocol protocol;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelOptionCard({
    super.key,
    required this.protocol,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<LevelOptionCard> createState() => _LevelOptionCardState();
}

class _LevelOptionCardState extends State<LevelOptionCard> {
  bool _isHovered = false;

  IconData _getIcon() {
    switch (widget.protocol) {
      case SecurityProtocol.novice:
        return Icons.lock_open_rounded;
      case SecurityProtocol.breacher:
        return Icons.lock_outline_rounded;
      case SecurityProtocol.expert:
        return Icons.enhanced_encryption_rounded;
      case SecurityProtocol.ghost:
        return Icons.visibility_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _isHovered;
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Glow backdrop behind card when selected or hovered
            if (active)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),

            // Card container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? DesignTokens.surfaceContainerHighest.withValues(alpha: 0.8)
                    : DesignTokens.surfaceContainerHigh.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                border: Border.all(
                  color: widget.isSelected
                      ? DesignTokens.primaryNeonCyan
                      : (_isHovered
                          ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.5)
                          : DesignTokens.outlineVariant),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Icon(
                          _getIcon(),
                          size: 30,
                          color: widget.isSelected
                              ? DesignTokens.primaryNeonCyan
                              : (_isHovered
                                  ? DesignTokens.primaryNeonCyan.withValues(alpha: 0.7)
                                  : DesignTokens.onSurfaceVariant),
                        ),
                        const SizedBox(width: 16),

                        // Title & Description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.protocol.title,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                  color: widget.isSelected
                                      ? DesignTokens.primaryNeonCyan
                                      : DesignTokens.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.protocol.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: DesignTokens.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
