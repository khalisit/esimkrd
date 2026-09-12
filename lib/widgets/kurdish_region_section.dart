import 'package:flutter/material.dart';

import '../models/country.dart';
import '../theme/app_colors.dart';
import '../utils/country_names.dart';
import 'country_flag_avatar.dart';
import 'fade_slide_in.dart';

class KurdishRegionSection extends StatelessWidget {
  const KurdishRegionSection({
    super.key,
    required this.countries,
    required this.title,
    required this.subtitle,
    required this.onCountryTap,
  });

  final List<Country> countries;
  final String title;
  final String subtitle;
  final ValueChanged<Country> onCountryTap;

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.flag_rounded, color: AppColors.primary.withValues(alpha: 0.7)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: countries.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final country = countries[index];
                final name = CountryNames.localized(context, country.code, country.name);

                return FadeSlideIn(
                  delay: Duration(milliseconds: 60 * index),
                  offsetY: 12,
                  child: _RegionCard(
                    code: country.code,
                    name: name,
                    onTap: () => onCountryTap(country),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionCard extends StatefulWidget {
  const _RegionCard({
    required this.code,
    required this.name,
    required this.onTap,
  });

  final String code;
  final String name;
  final VoidCallback onTap;

  @override
  State<_RegionCard> createState() => _RegionCardState();
}

class _RegionCardState extends State<_RegionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 132,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountryFlagAvatar(countryCode: widget.code, size: 40, borderRadius: 10),
              Text(
                widget.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
