import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/price_display.dart';

/// Order summary card shown during checkout (Airalo-style).
class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({
    super.key,
    required this.title,
    required this.countryCode,
    required this.countryName,
    required this.amountUsd,
    this.dataAmount,
    this.validityDays,
    this.amountIqd,
    this.orderId,
    this.summaryLabel,
    this.totalLabel,
  });

  final String title;
  final String countryCode;
  final String countryName;
  final double amountUsd;
  final String? dataAmount;
  final int? validityDays;
  final int? amountIqd;
  final int? orderId;
  final String? summaryLabel;
  final String? totalLabel;

  String? get _packageMeta {
    final parts = <String>[
      if (dataAmount != null && dataAmount!.isNotEmpty) dataAmount!,
      if (validityDays != null && validityDays! > 0) '$validityDays days',
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summaryLabel != null) ...[
            Text(
              summaryLabel!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CountryFlagAvatar(
                countryCode: countryCode,
                countryName: countryName,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      countryName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_packageMeta != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _packageMeta!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (orderId != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '#$orderId',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  totalLabel ?? 'Total',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              PriceDisplay(
                amountUsd: amountUsd,
                amountIqd: amountIqd,
                primaryStyle: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
                secondaryStyle: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SecurePaymentFooter extends StatelessWidget {
  const SecurePaymentFooter({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_rounded, size: 14, color: AppColors.success.withValues(alpha: 0.9)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
          ),
        ),
      ],
    );
  }
}
