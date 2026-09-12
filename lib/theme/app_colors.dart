import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFFFF6B2B);
  static const primaryDark = Color(0xFFE85518);
  static const primaryLight = Color(0xFFFF8A56);

  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3F4F6);

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF4B5563);
  static const textMuted = Color(0xFF9CA3AF);

  static const border = Color(0xFFE5E7EB);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );

  static const gradientGlow = RadialGradient(
    colors: [
      Color(0x33FF6B2B),
      Color(0x00FF6B2B),
    ],
  );
}
