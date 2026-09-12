import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/checkout_order.dart';
import '../theme/app_colors.dart';
import '../utils/currency_format.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/primary_button.dart';

/// Order review before opening FIB or Stripe checkout.
class PaymentConfirmSheet extends StatelessWidget {
  const PaymentConfirmSheet({super.key, required this.checkout});

  final CheckoutOrder checkout;

  static Future<bool?> show(BuildContext context, CheckoutOrder checkout) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentConfirmSheet(checkout: checkout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isCard = checkout.isCardCheckout;
    final payLabel = isCard
        ? l10n.payAmount(CurrencyFormat.usd(checkout.amountUsd))
        : l10n.continueToPay;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isCard ? l10n.securePayment : l10n.fibPaymentTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              isCard ? l10n.cardCheckoutSubtitle : l10n.fibPaymentSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 18),
            CheckoutOrderSummary(
              title: checkout.packageTitle,
              countryCode: checkout.countryCode,
              countryName: checkout.countryName,
              amountUsd: checkout.amountUsd,
              amountIqd: isCard ? null : checkout.amountIqd,
              dataAmount: checkout.dataAmount,
              validityDays: checkout.validityDays,
              orderId: checkout.orderId,
              summaryLabel: l10n.orderSummary,
              totalLabel: l10n.total,
            ),
            const SizedBox(height: 16),
            if (isCard)
              _TrustRow(label: l10n.securedByStripe)
            else
              _FibStepsCompact(l10n: l10n),
            const SizedBox(height: 20),
            PrimaryButton(
              label: payLabel,
              icon: isCard ? Icons.lock_rounded : Icons.arrow_forward_rounded,
              onPressed: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 12),
            SecurePaymentFooter(
              label: isCard ? l10n.cardSheetHint : l10n.fibSheetHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user_rounded, size: 18, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 6,
                  children: const [
                    _MiniBrand(label: 'Visa'),
                    _MiniBrand(label: 'Mastercard'),
                    _MiniBrand(label: 'Apple Pay'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBrand extends StatelessWidget {
  const _MiniBrand({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _FibStepsCompact extends StatelessWidget {
  const _FibStepsCompact({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final steps = [l10n.fibStep1, l10n.fibStep2, l10n.fibStep3, l10n.fibStep4];

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          _CompactStep(number: i + 1, text: steps[i], isLast: i == steps.length - 1),
          if (i < steps.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _CompactStep extends StatelessWidget {
  const _CompactStep({
    required this.number,
    required this.text,
    required this.isLast,
  });

  final int number;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: isLast ? AppColors.gradientPrimary : null,
                color: isLast ? null : AppColors.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLast ? Colors.transparent : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isLast ? Colors.white : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.35,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
