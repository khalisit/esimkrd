import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/checkout_selection.dart';
import '../models/package.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/currency_format.dart';
import '../widgets/price_display.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/fade_slide_in.dart';

/// Checkout sheet — order summary + payment method (FIB or card).
class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({
    super.key,
    required this.package,
    required this.api,
    this.initialPromoCode,
  });

  final EsimPackage package;
  final ApiClient api;
  final String? initialPromoCode;

  static const _fibLogo = 'assets/images/fib.png';
  static const _cardLogo = 'assets/images/card.png';

  static Future<CheckoutSelection?> show(
    BuildContext context, {
    required EsimPackage package,
    required ApiClient api,
    String? initialPromoCode,
  }) {
    return showModalBottomSheet<CheckoutSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (_) => PaymentMethodSheet(
        package: package,
        api: api,
        initialPromoCode: initialPromoCode,
      ),
    );
  }

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  late final TextEditingController _promoController;
  String? _appliedPromo;
  double? _discountUsd;
  double? _finalUsd;
  bool _validatingPromo = false;
  String? _promoError;

  @override
  void initState() {
    super.initState();
    _promoController = TextEditingController(text: widget.initialPromoCode ?? '');
    if (widget.initialPromoCode != null) {
      _validatePromo();
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  int get _amountIqd {
    final usd = _finalUsd ?? widget.package.retailPriceUsd;
    return (usd * AppConfig.usdToIqd).round();
  }

  String? _packageMeta(EsimPackage pkg) {
    final parts = <String>[
      if (pkg.dataAmount != null && pkg.dataAmount!.isNotEmpty) pkg.dataAmount!,
      if (pkg.validityDays > 0) '${pkg.validityDays} days',
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  Future<void> _validatePromo() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _appliedPromo = null;
        _discountUsd = null;
        _finalUsd = null;
        _promoError = null;
      });
      return;
    }

    setState(() {
      _validatingPromo = true;
      _promoError = null;
    });

    try {
      final response = await widget.api.post(
        '/promo-codes/validate',
        body: {
          'code': code,
          'amount_usd': widget.package.retailPriceUsd,
        },
      );
      final data = response['data'] as Map<String, dynamic>;
      setState(() {
        _appliedPromo = data['code'] as String?;
        _discountUsd = (data['discount_usd'] as num?)?.toDouble();
        _finalUsd = (data['final_usd'] as num?)?.toDouble();
      });
    } catch (e) {
      setState(() {
        _appliedPromo = null;
        _discountUsd = null;
        _finalUsd = null;
        _promoError = e.toString();
      });
    } finally {
      if (mounted) setState(() => _validatingPromo = false);
    }
  }

  void _selectMethod(BuildContext context, String method) {
    HapticFeedback.lightImpact();
    Navigator.pop(
      context,
      CheckoutSelection(
        paymentMethod: method,
        promoCode: _appliedPromo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    final meta = _packageMeta(widget.package);
    final displayUsd = _finalUsd ?? widget.package.retailPriceUsd;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom > 0 ? 0 : 8),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.12),
              blurRadius: 48,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 32,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 40),
                        offsetY: 12,
                        child: _SheetHeader(
                          title: l10n.checkoutTitle,
                          onClose: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 100),
                        offsetY: 16,
                        child: _OrderCard(
                          title: widget.package.title,
                          countryCode: widget.package.countryCode,
                          countryName: widget.package.countryName,
                          meta: meta,
                          amountUsd: displayUsd,
                          amountIqd: _amountIqd,
                          summaryLabel: l10n.orderSummary,
                          totalLabel: l10n.total,
                          discountUsd: _discountUsd,
                          discountLabel: l10n.promoDiscount,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 150),
                        offsetY: 12,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: l10n.promoCodeLabel,
                                  hintText: l10n.promoCodeHint,
                                  errorText: _promoError,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: _validatingPromo ? null : _validatePromo,
                                child: _validatingPromo
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(l10n.promoApply),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 180),
                        offsetY: 12,
                        child: Text(
                          l10n.paymentMethodTitle,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 240),
                        offsetY: 14,
                        child: _AnimatedPaymentOption(
                          imageAsset: PaymentMethodSheet._fibLogo,
                          title: l10n.paymentMethodFib,
                          subtitle: l10n.paymentMethodFibDesc,
                          onTap: () => _selectMethod(context, 'fib'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 310),
                        offsetY: 14,
                        child: _AnimatedPaymentOption(
                          imageAsset: PaymentMethodSheet._cardLogo,
                          title: l10n.paymentMethodCard,
                          subtitle: l10n.paymentMethodCardDesc,
                          onTap: () => _selectMethod(context, 'card'),
                        ),
                      ),
                      const SizedBox(height: 22),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 380),
                        offsetY: 8,
                        child: SecurePaymentFooter(label: l10n.checkoutDisclaimer),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatefulWidget {
  const _SheetHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  State<_SheetHeader> createState() => _SheetHeaderState();
}

class _SheetHeaderState extends State<_SheetHeader> {
  bool _closePressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        GestureDetector(
          onTapDown: (_) => setState(() => _closePressed = true),
          onTapUp: (_) {
            setState(() => _closePressed = false);
            widget.onClose();
          },
          onTapCancel: () => setState(() => _closePressed = false),
          child: AnimatedScale(
            scale: _closePressed ? 0.88 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _closePressed
                    ? AppColors.border
                    : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.title,
    required this.countryCode,
    required this.countryName,
    required this.meta,
    required this.amountUsd,
    required this.amountIqd,
    required this.summaryLabel,
    required this.totalLabel,
    this.discountUsd,
    this.discountLabel,
  });

  final String title;
  final String countryCode;
  final String countryName;
  final String? meta;
  final double amountUsd;
  final int amountIqd;
  final String summaryLabel;
  final String totalLabel;
  final double? discountUsd;
  final String? discountLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = meta != null ? '$countryName · $meta' : countryName;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 24,
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
              height: 3,
              decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summaryLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CountryFlagAvatar(
                        countryCode: countryCode,
                        countryName: countryName,
                        size: 48,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (discountUsd != null && discountUsd! > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          discountLabel ?? 'Discount',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '-${CurrencyFormat.usd(discountUsd!)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Text(
                          totalLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        PriceDisplay(
                          amountUsd: amountUsd,
                          amountIqd: amountIqd,
                          primaryStyle: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                          secondaryStyle: theme.textTheme.bodySmall?.copyWith(
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
    );
  }
}

class _AnimatedPaymentOption extends StatefulWidget {
  const _AnimatedPaymentOption({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_AnimatedPaymentOption> createState() => _AnimatedPaymentOptionState();
}

class _AnimatedPaymentOptionState extends State<_AnimatedPaymentOption> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: _pressed
                ? AppColors.surfaceMuted
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.border.withValues(alpha: 0.85),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: _pressed
                ? null
                : [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _pressed
                      ? AppColors.surface
                      : AppColors.surfaceMuted.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(widget.imageAsset, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSlide(
                offset: _pressed ? const Offset(0.08, 0) : Offset.zero,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: _pressed
                      ? AppColors.primary
                      : AppColors.textMuted.withValues(alpha: 0.7),
                  textDirection: Directionality.of(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
