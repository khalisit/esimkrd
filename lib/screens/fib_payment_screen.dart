import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/checkout_order.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/currency_format.dart';
import '../utils/page_transitions.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/glow_background.dart';
import '../widgets/primary_button.dart';
import 'payment_result_screen.dart';

/// Manual FIB transfer — customer sends IQD with order reference.
class FibPaymentScreen extends StatefulWidget {
  const FibPaymentScreen({
    super.key,
    required this.api,
    required this.checkout,
  });

  final ApiClient api;
  final CheckoutOrder checkout;

  @override
  State<FibPaymentScreen> createState() => _FibPaymentScreenState();
}

class _FibPaymentScreenState extends State<FibPaymentScreen> {
  var _submitting = false;
  var _activeStep = 0;

  Future<void> _copy(String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedToClipboard(label)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _markPaid() async {
    setState(() => _submitting = true);
    try {
      await widget.api.post(
        '/orders/${widget.checkout.orderId}/payment-sent',
        auth: true,
      );
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        AppPageRoute(
          page: PaymentResultScreen(
            api: widget.api,
            orderId: widget.checkout.orderId,
            paymentReturned: true,
            manualVerification: true,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.paymentFailed)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checkout = widget.checkout;

    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(l10n.fibPaymentTitle),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _StepHeader(
                  activeStep: _activeStep,
                  labels: [
                    l10n.fibStep1,
                    l10n.fibStep2,
                    l10n.fibStep3,
                    l10n.fibStep4,
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CheckoutOrderSummary(
                        title: checkout.packageTitle,
                        countryCode: checkout.countryCode,
                        countryName: checkout.countryName,
                        amountUsd: checkout.amountUsd,
                        amountIqd: checkout.amountIqd,
                        dataAmount: checkout.dataAmount,
                        validityDays: checkout.validityDays,
                        orderId: checkout.orderId,
                        summaryLabel: l10n.orderSummary,
                        totalLabel: l10n.total,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.fibTransferDetails,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _CopyField(
                        label: l10n.fibPhoneLabel,
                        value: checkout.fibAccountPhone,
                        subtitle: checkout.fibAccountName,
                        onCopy: checkout.fibAccountPhone.isNotEmpty
                            ? () => _copy(checkout.fibAccountPhone, l10n.fibPhoneLabel)
                            : null,
                        onFocus: () => setState(() => _activeStep = 0),
                      ),
                      if (checkout.fibAccountIban.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _CopyField(
                          label: l10n.fibIbanLabel,
                          value: checkout.fibAccountIban,
                          onCopy: () => _copy(checkout.fibAccountIban, l10n.fibIbanLabel),
                          onFocus: () => setState(() => _activeStep = 0),
                        ),
                      ],
                      const SizedBox(height: 10),
                      _CopyField(
                        label: l10n.fibReferenceLabel,
                        value: checkout.referenceCode,
                        highlight: true,
                        onCopy: checkout.referenceCode.isNotEmpty
                            ? () => _copy(checkout.referenceCode, l10n.fibReferenceLabel)
                            : null,
                        onFocus: () => setState(() => _activeStep = 2),
                      ),
                      const SizedBox(height: 10),
                      _AmountHighlight(
                        label: l10n.total,
                        value: CurrencyFormat.iqd(checkout.amountIqd),
                        onTap: () => setState(() => _activeStep = 1),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.fibPaymentNote,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      label: l10n.fibMarkPaid,
                      icon: Icons.check_circle_outline_rounded,
                      loading: _submitting,
                      onPressed: _submitting
                          ? null
                          : () {
                              setState(() => _activeStep = 3);
                              _markPaid();
                            },
                    ),
                    const SizedBox(height: 8),
                    SecurePaymentFooter(label: l10n.fibSheetHint),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.activeStep,
    required this.labels,
  });

  final int activeStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final done = index < activeStep;
        final active = index == activeStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: done || active ? AppColors.gradientPrimary : null,
                    color: done || active ? null : AppColors.border,
                  ),
                ),
              ),
              if (index < labels.length - 1) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}

class _CopyField extends StatelessWidget {
  const _CopyField({
    required this.label,
    required this.value,
    this.subtitle,
    this.highlight = false,
    this.onCopy,
    this.onFocus,
  });

  final String label;
  final String value;
  final String? subtitle;
  final bool highlight;
  final VoidCallback? onCopy;
  final VoidCallback? onFocus;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight
          ? AppColors.primary.withValues(alpha: 0.05)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onFocus,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                            color: highlight ? AppColors.primary : null,
                          ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onCopy != null)
                IconButton.filledTonal(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountHighlight extends StatelessWidget {
  const _AmountHighlight({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: AppColors.gradientPrimary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
