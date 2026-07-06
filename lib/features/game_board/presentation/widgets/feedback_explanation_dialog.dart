import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import 'feedback_pegs_widget.dart';

class FeedbackExplanationDialog extends StatelessWidget {
  const FeedbackExplanationDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'SEQUENCE FEEDBACK',
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
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: DesignTokens.primaryNeonCyan.withValues(alpha: 0.7),
                          ),
                        ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PegWidget(
                    peg: PegData(DesignTokens.feedbackGreen, isGlow: true),
                    size: 10,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Green = Correct colour, correct location',
                      style: TextStyle(
                        fontFamily: DesignTokens.bodyFont,
                        fontSize: 13,
                        color: DesignTokens.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PegWidget(
                    peg: PegData(DesignTokens.feedbackYellow, isGlow: true),
                    size: 10,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Yellow = Correct colour, wrong location',
                      style: TextStyle(
                        fontFamily: DesignTokens.bodyFont,
                        fontSize: 13,
                        color: DesignTokens.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
