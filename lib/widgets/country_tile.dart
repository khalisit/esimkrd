import 'package:flutter/material.dart';

import '../config/regional_countries.dart';
import '../models/country.dart';
import '../theme/app_colors.dart';
import '../utils/country_names.dart';
import 'app_card.dart';
import 'country_flag_avatar.dart';

class CountryTile extends StatefulWidget {
  const CountryTile({
    super.key,
    required this.country,
    required this.onTap,
    this.index = 0,
  });

  final Country country;
  final VoidCallback onTap;
  final int index;

  @override
  State<CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<CountryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final displayName = CountryNames.localized(context, widget.country.code, widget.country.name);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.01 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AppCard(
          onTap: widget.onTap,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CountryFlagAvatar(
                countryCode: widget.country.code,
                countryName: widget.country.name,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (!RegionalCountries.isKurdistan(widget.country.code))
                      Text(
                        widget.country.code,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                      ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _hovered ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
