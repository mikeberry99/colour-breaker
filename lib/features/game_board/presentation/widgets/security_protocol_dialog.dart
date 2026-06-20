import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../domain/entities/security_protocol.dart';
import '../../../level_selection/presentation/providers/level_selection_provider.dart';

class SecurityProtocolDialog extends StatelessWidget {
  final SecurityProtocol protocol;

  const SecurityProtocolDialog({
    super.key,
    required this.protocol,
  });

  IconData _getIcon() {
    switch (protocol) {
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

  List<String> _getBulletPoints() {
    switch (protocol) {
      case SecurityProtocol.novice:
        return [
          'Four slot sequence to guess from 6 potential colours',
          'Each colour appears once in each sequence',
          'Unlimited attempts',
        ];
      case SecurityProtocol.breacher:
        return [
          'Four slot sequence to guess from 6 potential colours',
          'Each colour appears one or more times',
          '10 attempts to solve sequence',
        ];
      case SecurityProtocol.expert:
        return [
          'Five slot sequence to guess from 6 potential colours',
          'Each colour appears once in each sequence',
          '25 attempts to solve sequence',
        ];
      case SecurityProtocol.ghost:
        return [
          'Five slot sequence to guess from 6 potential colours',
          'Each colour appears one or more times',
          '15 attempts to solve sequence',
        ];
    }
  }

  IconData _getBulletIcon(int index) {
    switch (index) {
      case 0:
        return Icons.password_rounded;
      case 1:
        return Icons.color_lens_outlined;
      case 2:
        return protocol == SecurityProtocol.novice
            ? Icons.all_inclusive_rounded
            : Icons.replay_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bullets = _getBulletPoints();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: DesignTokens.background,
          borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
          border: Border.all(
            color: DesignTokens.primaryNeonCyan,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.gutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SECURITY PROTOCOL',
                    style: TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.primaryNeonCyan,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 1,
                color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              // Protocol Header Title and Icon
              Row(
                children: [
                  Icon(
                    _getIcon(),
                    color: DesignTokens.primaryNeonCyan,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    protocol.title,
                    style: const TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.primaryNeonCyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bullet Points
              ...List.generate(bullets.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          _getBulletIcon(index),
                          color: DesignTokens.primaryNeonCyan,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bullets[index],
                          style: const TextStyle(
                            fontFamily: DesignTokens.bodyFont,
                            fontSize: 13,
                            color: DesignTokens.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: DesignTokens.primaryNeonCyan,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusDefault),
                      side: BorderSide(
                        color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(
                      fontFamily: DesignTokens.labelFont,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
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
