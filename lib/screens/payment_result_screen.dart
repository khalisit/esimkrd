import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/order_receipt.dart';
import '../widgets/glow_background.dart';
import '../widgets/primary_button.dart';

class PaymentResultScreen extends StatefulWidget {
  const PaymentResultScreen({
    super.key,
    required this.api,
    required this.orderId,
    this.paymentReturned = false,
    this.manualVerification = false,
  });

  final ApiClient api;
  final int orderId;
  final bool paymentReturned;
  final bool manualVerification;

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

enum _PaymentStatus { confirming, success, pending, failed }

class _PaymentResultScreenState extends State<PaymentResultScreen>
    with SingleTickerProviderStateMixin {
  _PaymentStatus _status = _PaymentStatus.confirming;
  Timer? _pollTimer;
  var _attempts = 0;
  Map<String, dynamic>? _orderDetails;
  late final AnimationController _pulse;

  static const _maxAttempts = 15;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    if (widget.manualVerification) {
      _status = _PaymentStatus.pending;
      return;
    }

    _pollOrder();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _pollOrder());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _pollOrder() async {
    if (_status == _PaymentStatus.success || _attempts >= _maxAttempts) {
      _pollTimer?.cancel();
      return;
    }

    _attempts++;

    try {
      final response = await widget.api.get('/orders/${widget.orderId}', auth: true);
      final order = response['data'] as Map<String, dynamic>;
      final status = order['status'] as String? ?? 'pending';

      if (!mounted) return;

      if (status == 'paid' || status == 'completed' || status == 'delivered') {
        setState(() {
          _status = _PaymentStatus.success;
          _orderDetails = order;
        });
        _pollTimer?.cancel();
        return;
      }

      if (_attempts >= _maxAttempts) {
        setState(() => _status = _PaymentStatus.pending);
        _pollTimer?.cancel();
      }
    } catch (_) {
      if (_attempts >= _maxAttempts && mounted) {
        setState(() => _status = _PaymentStatus.failed);
        _pollTimer?.cancel();
      }
    }
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _shareReceipt(AppLocalizations l10n) async {
    if (_orderDetails == null) return;
    final text = OrderReceipt.fromOrderJson(_orderDetails!);
    await SharePlus.instance.share(ShareParams(text: text, subject: l10n.receiptTitle));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                _StatusVisual(status: _status, pulse: _pulse),
                const SizedBox(height: 28),
                Text(
                  _title(l10n),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  _subtitle(l10n),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const Spacer(),
                if (_status == _PaymentStatus.success) ...[
                  PrimaryButton(
                    label: l10n.viewMyEsims,
                    icon: Icons.sim_card_rounded,
                    onPressed: _goHome,
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: l10n.shareReceipt,
                    icon: Icons.ios_share_rounded,
                    onPressed: () => _shareReceipt(l10n),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: l10n.continueShopping,
                    onPressed: _goHome,
                  ),
                ] else if (_status == _PaymentStatus.pending) ...[
                  PrimaryButton(
                    label: l10n.viewMyEsims,
                    icon: Icons.sim_card_rounded,
                    onPressed: _goHome,
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: l10n.retry,
                    onPressed: () {
                      setState(() {
                        _status = _PaymentStatus.confirming;
                        _attempts = 0;
                      });
                      _pollOrder();
                      _pollTimer ??= Timer.periodic(
                        const Duration(seconds: 2),
                        (_) => _pollOrder(),
                      );
                    },
                  ),
                ] else if (_status == _PaymentStatus.failed) ...[
                  PrimaryButton(
                    label: l10n.retry,
                    icon: Icons.refresh_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: l10n.continueShopping,
                    onPressed: _goHome,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) {
    if (widget.manualVerification && _status == _PaymentStatus.pending) {
      return l10n.fibManualPendingTitle;
    }
    return switch (_status) {
      _PaymentStatus.confirming => l10n.confirmingPayment,
      _PaymentStatus.success => l10n.paymentSuccess,
      _PaymentStatus.pending => l10n.paymentPending,
      _PaymentStatus.failed => l10n.paymentFailed,
    };
  }

  String _subtitle(AppLocalizations l10n) {
    if (widget.manualVerification && _status == _PaymentStatus.pending) {
      return l10n.fibManualPendingSubtitle;
    }
    return switch (_status) {
      _PaymentStatus.confirming => l10n.confirmingPaymentSubtitle,
      _PaymentStatus.success => l10n.paymentSuccessSubtitle,
      _PaymentStatus.pending => l10n.paymentPendingSubtitle,
      _PaymentStatus.failed => l10n.paymentFailedSubtitle,
    };
  }
}

class _StatusVisual extends StatelessWidget {
  const _StatusVisual({required this.status, required this.pulse});

  final _PaymentStatus status;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      _PaymentStatus.confirming => ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.05).animate(
            CurvedAnimation(parent: pulse, curve: Curves.easeInOut),
          ),
          child: _IconCircle(
            color: AppColors.primary,
            icon: Icons.hourglass_top_rounded,
          ),
        ),
      _PaymentStatus.success => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) => Transform.scale(scale: value, child: child),
          child: _IconCircle(
            color: AppColors.success,
            icon: Icons.check_rounded,
            size: 40,
          ),
        ),
      _PaymentStatus.pending => _IconCircle(
          color: AppColors.primary,
          icon: Icons.schedule_rounded,
        ),
      _PaymentStatus.failed => _IconCircle(
          color: AppColors.error,
          icon: Icons.close_rounded,
        ),
    };
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.color,
    required this.icon,
    this.size = 36,
  });

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}
