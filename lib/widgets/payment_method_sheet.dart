import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/checkout_selection.dart';
import '../models/package.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/price_display.dart';

/// Centered checkout confirm — package summary only, then go to payment.
class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({
    super.key,
    required this.package,
    this.displayCountryCode,
    this.displayCountryName,
  });

  final EsimPackage package;
  /// When browsing Kurdistan (`KRD`), packages still come from Iraq (`IQ`).
  /// Pass the screen country so the flag/name match what the user selected.
  final String? displayCountryCode;
  final String? displayCountryName;

  static Future<CheckoutSelection?> show(
    BuildContext context, {
    required EsimPackage package,
    ApiClient? api,
    String? initialPromoCode,
    String? displayCountryCode,
    String? displayCountryName,
  }) {
    return showGeneralDialog<CheckoutSelection>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PaymentMethodSheet(
          package: package,
          displayCountryCode: displayCountryCode,
          displayCountryName: displayCountryName,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  String get _flagCode => displayCountryCode ?? package.countryCode;

  String get _countryLabel =>
      (displayCountryName != null && displayCountryName!.trim().isNotEmpty)
          ? displayCountryName!
          : package.countryName;

  String? _packageMeta(EsimPackage pkg) {
    final parts = <String>[
      if (pkg.dataAmount != null && pkg.dataAmount!.isNotEmpty) pkg.dataAmount!,
      if (pkg.validityDays > 0) '${pkg.validityDays} days',
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  void _confirm(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pop(
      context,
      const CheckoutSelection(paymentMethod: 'rasedi'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final meta = _packageMeta(package);
    final amountIqd = (package.retailPriceUsd * AppConfig.usdToIqd).round();
    final subtitle = meta != null ? '$_countryLabel · $meta' : _countryLabel;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.14),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 40),
                        offsetY: 8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.checkoutTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceMuted,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 90),
                        offsetY: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.75),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.gradientPrimary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.orderSummary,
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CountryFlagAvatar(
                                            countryCode: _flagCode,
                                            countryName: _countryLabel,
                                            size: 46,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  package.title,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: theme.textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  subtitle,
                                                  style: theme.textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 11,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceMuted
                                              .withValues(alpha: 0.7),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              l10n.total,
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            PriceDisplay(
                                              amountUsd: package.retailPriceUsd,
                                              amountIqd: amountIqd,
                                              primaryStyle: theme
                                                  .textTheme.titleLarge
                                                  ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.4,
                                              ),
                                              secondaryStyle: theme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 140),
                        offsetY: 10,
                        child: SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: () => _confirm(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              l10n.continueToPay,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 180),
                        offsetY: 6,
                        child: SecurePaymentFooter(
                          label: l10n.checkoutDisclaimer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
