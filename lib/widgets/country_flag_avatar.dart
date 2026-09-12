import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../config/regional_countries.dart';
import '../config/country_flag_codes.dart';
import '../theme/app_colors.dart';
import 'kurdistan_flag.dart';

class CountryFlagAvatar extends StatelessWidget {
  const CountryFlagAvatar({
    super.key,
    required this.countryCode,
    this.countryName,
    this.size = 48,
    this.borderRadius = 14,
  });

  final String countryCode;
  final String? countryName;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (RegionalCountries.isKurdistan(countryCode)) {
      return KurdistanFlag(size: size, borderRadius: borderRadius);
    }

    final flagCode = CountryFlagCodes.resolve(
      countryCode,
      countryName: countryName,
    );

    if (flagCode != null) {
      return _FlagFrame(
        size: size,
        borderRadius: borderRadius,
        child: _SafeCountryFlag(code: flagCode, size: size),
      );
    }

    if (CountryFlagCodes.isRegionalCode(countryCode) ||
        (countryName != null && countryName!.trim().isNotEmpty)) {
      return _RegionBadge(
        size: size,
        borderRadius: borderRadius,
        countryName: countryName ?? countryCode,
      );
    }

    return _FallbackGlobe(size: size, borderRadius: borderRadius);
  }
}

class CountryFlagBadge extends StatelessWidget {
  const CountryFlagBadge({
    super.key,
    required this.countryCode,
    this.countryName,
    this.size = 22,
  });

  final String countryCode;
  final String? countryName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CountryFlagAvatar(
      countryCode: countryCode,
      countryName: countryName,
      size: size,
      borderRadius: size * 0.28,
    );
  }
}

class _FlagFrame extends StatelessWidget {
  const _FlagFrame({
    required this.size,
    required this.borderRadius,
    required this.child,
  });

  final double size;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _SafeCountryFlag extends StatelessWidget {
  const _SafeCountryFlag({required this.code, required this.size});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    try {
      return CountryFlag.fromCountryCode(
        code,
        height: size,
        width: size,
      );
    } catch (_) {
      return _FallbackGlobe(size: size, borderRadius: size * 0.28);
    }
  }
}

class _RegionBadge extends StatelessWidget {
  const _RegionBadge({
    required this.size,
    required this.borderRadius,
    required this.countryName,
  });

  final double size;
  final double borderRadius;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    final style = _regionStyle(countryName);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.colors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(style.icon, size: size * 0.48, color: Colors.white),
    );
  }

  static ({List<Color> colors, IconData icon}) _regionStyle(String name) {
    final key = name.trim().toLowerCase();
    if (key.contains('africa')) {
      return (
        colors: const [Color(0xFFE67E22), Color(0xFFD35400)],
        icon: Icons.public_rounded,
      );
    }
    if (key.contains('europe')) {
      return (
        colors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        icon: Icons.public_rounded,
      );
    }
    if (key.contains('asia')) {
      return (
        colors: const [Color(0xFFEF4444), Color(0xFFB91C1C)],
        icon: Icons.travel_explore_rounded,
      );
    }
    if (key.contains('middle east') || key.contains('mena')) {
      return (
        colors: const [Color(0xFF0D9488), Color(0xFF0F766E)],
        icon: Icons.explore_rounded,
      );
    }
    if (key.contains('north america')) {
      return (
        colors: const [Color(0xFF6366F1), Color(0xFF4338CA)],
        icon: Icons.public_rounded,
      );
    }
    if (key.contains('latin') || key.contains('south america')) {
      return (
        colors: const [Color(0xFF22C55E), Color(0xFF15803D)],
        icon: Icons.public_rounded,
      );
    }
    if (key.contains('caribbean')) {
      return (
        colors: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
        icon: Icons.beach_access_rounded,
      );
    }
    if (key.contains('oceania') || key.contains('pacific')) {
      return (
        colors: const [Color(0xFF14B8A6), Color(0xFF0F766E)],
        icon: Icons.sailing_rounded,
      );
    }
    if (key.contains('global') || key.contains('world')) {
      return (
        colors: const [AppColors.primary, AppColors.primaryDark],
        icon: Icons.language_rounded,
      );
    }
    return (
      colors: const [AppColors.primaryLight, AppColors.primary],
      icon: Icons.public_rounded,
    );
  }
}

class _FallbackGlobe extends StatelessWidget {
  const _FallbackGlobe({required this.size, required this.borderRadius});

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(Icons.public_rounded, size: size * 0.48, color: AppColors.textMuted),
    );
  }
}
