import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final bool isGlowing;

  const GlassContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.borderRadius = DesignTokens.radiusLg,
    this.borderColor = Colors.transparent,
    this.padding,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isGlowing
            ? [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor != Colors.transparent ? borderColor : Colors.white.withValues(alpha: 0.1),
                width: borderColor != Colors.transparent ? 2.0 : 0.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
