import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/package.dart';
import '../theme/app_colors.dart';
import '../widgets/price_display.dart';
import 'primary_button.dart';

class PackageTile extends StatelessWidget {
  const PackageTile({
    super.key,
    required this.package,
    required this.onBuy,
    this.buying = false,
  });

  final EsimPackage package;
  final VoidCallback? onBuy;
  final bool buying;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUnlimited = package.dataAmount?.toLowerCase() == 'unlimited';
    final dataLabel = isUnlimited ? l10n.unlimited : (package.dataAmount ?? '—');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DataBadge(
                    label: dataLabel,
                    isUnlimited: isUnlimited,
                    days: l10n.daysCount(package.validityDays),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 14,
                              color: AppColors.primary.withValues(alpha: 0.85),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                l10n.packageDetails,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _PriceTag(price: package.retailPriceUsd),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: PrimaryButton(
                label: l10n.buy,
                icon: Icons.shopping_bag_outlined,
                loading: buying,
                onPressed: onBuy,
                height: 42,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataBadge extends StatelessWidget {
  const _DataBadge({
    required this.label,
    required this.isUnlimited,
    required this.days,
  });

  final String label;
  final bool isUnlimited;
  final String days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.14),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(
            isUnlimited ? Icons.all_inclusive_rounded : Icons.cell_tower_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  height: 1.1,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            days,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: PriceDisplay(
        amountUsd: price,
        primaryStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          height: 1,
        ),
        secondaryStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 11,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
