import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/checkout_order.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/currency_format.dart';
import '../utils/page_transitions.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/glow_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/primary_button.dart';
import 'payment_result_screen.dart';

const _fibGreen = Color(0xFF1B7F5D);
const _fibLogo = 'assets/images/fib.png';
const _qrSize = 118.0;
const _pagePad = 20.0;

/// FIB automatic payment — QR code, app links, and status polling.
class FibQrScreen extends StatefulWidget {
  const FibQrScreen({super.key, required this.api, required this.checkout});

  final ApiClient api;
  final CheckoutOrder checkout;

  @override
  State<FibQrScreen> createState() => _FibQrScreenState();
}

class _FibQrScreenState extends State<FibQrScreen>
    with SingleTickerProviderStateMixin {
  Timer? _pollTimer;
  bool _checking = false;
  bool _resolved = false;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkStatus(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Uint8List? _decodeQr(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    var data = raw;
    final comma = data.indexOf(',');
    if (data.startsWith('data:') && comma != -1) {
      data = data.substring(comma + 1);
    }
    try {
      return base64Decode(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _checkStatus({bool manual = false}) async {
    if (_resolved) return;
    if (manual) setState(() => _checking = true);

    try {
      final response = await widget.api.get(
        '/orders/${widget.checkout.orderId}/fib-status',
        auth: true,
      );
      final data = response['data'] as Map<String, dynamic>?;
      final status = data?['status'] as String? ?? 'pending';

      if (!mounted) return;

      if (status == 'paid' || status == 'completed' || status == 'delivered') {
        _resolved = true;
        _pollTimer?.cancel();
        _goToResult();
      }
    } catch (_) {
      // Keep polling on transient errors.
    } finally {
      if (mounted && manual) setState(() => _checking = false);
    }
  }

  void _goToResult() {
    Navigator.of(context).pushReplacement(
      AppPageRoute(
        page: PaymentResultScreen(
          api: widget.api,
          orderId: widget.checkout.orderId,
          paymentReturned: true,
        ),
      ),
    );
  }

  Future<void> _openApp(String? link, AppLocalizations l10n) async {
    if (link == null || link.isEmpty) return;
    final uri = Uri.tryParse(link);
    if (uri == null) return;

    HapticFeedback.lightImpact();
    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fibAppNotInstalled)),
      );
    }
  }

  void _copyCode(String value, String copiedLabel) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copiedLabel),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checkout = widget.checkout;
    final qrBytes = _decodeQr(checkout.fibQrCode);
    final hasCode =
        checkout.fibReadableCode != null &&
        checkout.fibReadableCode!.isNotEmpty;
    final hasPersonal =
        checkout.fibPersonalLink != null &&
        checkout.fibPersonalLink!.isNotEmpty;
    final hasBusiness =
        checkout.fibBusinessLink != null &&
        checkout.fibBusinessLink!.isNotEmpty;

    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _ScreenHeader(
                    title: l10n.fibPayTitle,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        _pagePad,
                        0,
                        _pagePad,
                        130,
                      ),
                      child: Column(
                    children: [
                      const SizedBox(height: 4),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 50),
                        offsetY: 10,
                        child: _OrderSummaryCard(
                          amountIqd: checkout.amountIqd,
                          packageTitle: checkout.packageTitle,
                          countryName: checkout.countryName,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 130),
                        offsetY: 12,
                        child: Text(
                          l10n.fibScanTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 170),
                        offsetY: 8,
                        child: Text(
                          l10n.fibScanSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 220),
                        offsetY: 14,
                        child: _QrFrame(qrBytes: qrBytes),
                      ),
                      if (hasCode) ...[
                        const SizedBox(height: 14),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 290),
                          offsetY: 10,
                          child: _CopyCodeTile(
                            label: l10n.fibReadableCode,
                            value: checkout.fibReadableCode!,
                            onCopy: () => _copyCode(
                              checkout.fibReadableCode!,
                              l10n.copiedToClipboard(l10n.fibReadableCode),
                            ),
                          ),
                        ),
                      ],
                      if (hasPersonal || hasBusiness) ...[
                        const SizedBox(height: 14),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 350),
                          offsetY: 10,
                          child: Row(
                            children: [
                              if (hasPersonal)
                                Expanded(
                                  child: _AppLinkTile(
                                    icon: Icons.person_rounded,
                                    label: l10n.fibPersonalApp,
                                    onTap: () => _openApp(
                                      checkout.fibPersonalLink,
                                      l10n,
                                    ),
                                  ),
                                ),
                              if (hasPersonal && hasBusiness)
                                const SizedBox(width: 10),
                              if (hasBusiness)
                                Expanded(
                                  child: _AppLinkTile(
                                    icon: Icons.business_rounded,
                                    label: l10n.fibBusinessApp,
                                    onTap: () => _openApp(
                                      checkout.fibBusinessLink,
                                      l10n,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ),
                ],
              ),
              Positioned(
                left: _pagePad,
                right: _pagePad,
                bottom: 16,
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  offsetY: 8,
                  child: _BottomDock(
                    waitingLabel: l10n.fibWaitingPayment,
                    pulse: _pulse,
                    buttonLabel: l10n.fibCheckStatus,
                    loading: _checking,
                    onCheck: () => _checkStatus(manual: true),
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

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              backgroundColor: AppColors.surface.withValues(alpha: 0.85),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.amountIqd,
    required this.packageTitle,
    required this.countryName,
  });

  final int amountIqd;
  final String packageTitle;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _fibGreen.withValues(alpha: 0.85),
                    AppColors.primary.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(_fibLogo, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          packageTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          countryName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CurrencyFormat.iqd(amountIqd),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
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

class _QrFrame extends StatelessWidget {
  const _QrFrame({required this.qrBytes});

  final Uint8List? qrBytes;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _fibGreen.withValues(alpha: 0.18),
              AppColors.primary.withValues(alpha: 0.12),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: qrBytes != null
              ? Image.memory(
                  qrBytes!,
                  width: _qrSize,
                  height: _qrSize,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                )
              : SizedBox(
                  width: _qrSize,
                  height: _qrSize,
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 48,
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                  ),
                ),
        ),
      ),
    );
  }
}

class _CopyCodeTile extends StatefulWidget {
  const _CopyCodeTile({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  State<_CopyCodeTile> createState() => _CopyCodeTileState();
}

class _CopyCodeTileState extends State<_CopyCodeTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onCopy();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _pressed
                ? AppColors.surfaceMuted
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _pressed
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.border.withValues(alpha: 0.8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      widget.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.copy_rounded,
                size: 18,
                color: _pressed ? AppColors.primary : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLinkTile extends StatefulWidget {
  const _AppLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_AppLinkTile> createState() => _AppLinkTileState();
}

class _AppLinkTileState extends State<_AppLinkTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _pressed ? AppColors.surfaceMuted : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _pressed
                  ? _fibGreen.withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.85),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 17,
                color: _pressed ? _fibGreen : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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

class _BottomDock extends StatelessWidget {
  const _BottomDock({
    required this.waitingLabel,
    required this.pulse,
    required this.buttonLabel,
    required this.loading,
    required this.onCheck,
  });

  final String waitingLabel;
  final AnimationController pulse;
  final String buttonLabel;
  final bool loading;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 22,
      blurSigma: 5,
      fillOpacity: 0.46,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: pulse,
                builder: (context, _) => Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(
                      alpha: 0.45 + pulse.value * 0.45,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  waitingLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: buttonLabel,
            icon: Icons.refresh_rounded,
            loading: loading,
            height: 48,
            borderRadius: 14,
            onPressed: onCheck,
          ),
        ],
      ),
    );
  }
}
