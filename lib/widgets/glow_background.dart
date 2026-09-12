import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.background),
        Positioned(
          top: -80,
          right: -60,
          child: _GlowOrb(size: 280, opacity: 0.22),
        ),
        Positioned(
          top: 120,
          left: -100,
          child: _GlowOrb(size: 220, opacity: 0.12),
        ),
        Positioned(
          bottom: 80,
          right: -40,
          child: _GlowOrb(size: 180, opacity: 0.08),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primary.withValues(alpha: opacity),
            AppColors.primary.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
