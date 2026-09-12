import 'package:flutter/material.dart';

import 'country_flag_avatar.dart';
import 'kurdistan_flag.dart';

/// Language flag mapping:
/// - Kurdish → Kurdistan
/// - Arabic → Iraq
/// - English → Great Britain
class LanguageFlag extends StatelessWidget {
  const LanguageFlag({
    super.key,
    required this.languageCode,
    this.size = 28,
  });

  final String languageCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = size * 0.22;

    return switch (languageCode) {
      'ku' => KurdistanFlag(size: size, borderRadius: borderRadius),
      'ar' => CountryFlagBadge(countryCode: 'IQ', size: size),
      'en' => CountryFlagBadge(countryCode: 'GB', size: size),
      _ => CountryFlagBadge(countryCode: 'GB', size: size),
    };
  }
}
