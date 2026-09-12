import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/user_esim.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/esim_alerts.dart';
import '../widgets/esim_alert_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/top_up_sheet.dart';

/// Professional eSIM hub: live usage + install guides for iOS & Android.
class EsimDetailScreen extends StatefulWidget {
  const EsimDetailScreen({
    super.key,
    required this.api,
    required this.esim,
  });

  final ApiClient api;
  final UserEsim esim;

  @override
  State<EsimDetailScreen> createState() => _EsimDetailScreenState();
}

class _EsimDetailScreenState extends State<EsimDetailScreen>
    with SingleTickerProviderStateMixin {
  late UserEsim _esim;
  late TabController _tabs;
  var _loading = false;

  bool get _preferIos =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _esim = widget.esim;
    _tabs = TabController(length: 2, vsync: this, initialIndex: _preferIos ? 0 : 1);
    _refresh();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final response = await widget.api.get('/my-esims/${_esim.id}', auth: true);
      final data = response['data'] as Map<String, dynamic>;
      if (!mounted) return;
      setState(() => _esim = UserEsim.fromJson(data));
    } catch (_) {
      // Keep cached esim if refresh fails.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _copy(String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copiedToClipboard(label)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.esimOpenLinkFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.esimDetailTitle),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: l10n.esimRefreshUsage,
            onPressed: _loading ? null : _refresh,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 12, 20, 28 + bottom),
          children: [
            _HeroCard(esim: _esim, l10n: l10n),
            ...EsimAlerts.forEsim(_esim).map(
              (alert) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: EsimAlertBanner(alert: alert),
              ),
            ),
            const SizedBox(height: 16),
            _UsageCard(esim: _esim, l10n: l10n),
            const SizedBox(height: 22),
            PrimaryButton(
              label: l10n.topUpAction,
              icon: Icons.add_circle_outline_rounded,
              onPressed: () => TopUpSheet.show(context, api: widget.api, esim: _esim),
            ),
            const SizedBox(height: 22),
            Text(l10n.esimInstallHowTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              l10n.esimInstallHowSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabs,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: l10n.esimTabIphone),
                  Tab(text: l10n.esimTabAndroid),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: _tabs,
              builder: (context, _) {
                return _tabs.index == 0
                    ? _IosInstallPanel(
                        esim: _esim,
                        l10n: l10n,
                        onOpenApple: () => _openUrl(_esim.appleInstallUrl),
                        onCopy: _copy,
                      )
                    : _AndroidInstallPanel(
                        esim: _esim,
                        l10n: l10n,
                        onCopy: _copy,
                        onOpenShare: () => _openUrl(_esim.shareLink),
                      );
              },
            ),
            const SizedBox(height: 18),
            _ManualCodesCard(esim: _esim, l10n: l10n, onCopy: _copy),
            if (_esim.apnValue != null && _esim.apnValue!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _Note(text: l10n.esimApnHint(_esim.apnValue!)),
            ],
            const SizedBox(height: 12),
            _Note(text: l10n.esimRoamingHint),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.esim, required this.l10n});

  final UserEsim esim;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            esim.packageName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (esim.countryName != null && esim.countryName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              esim.countryName!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(label: _statusLabel(l10n, esim.usage?.status ?? esim.status)),
              if (esim.dataTotal != null) _Pill(label: esim.dataTotal!),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    return switch (status.toUpperCase()) {
      'ACTIVE' => l10n.statusActive,
      'EXPIRED' => l10n.statusExpired,
      'FINISHED' || 'DEPLETED' => l10n.statusDepleted,
      'NOT_ACTIVE' => l10n.esimStatusNotActive,
      _ => status,
    };
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({required this.esim, required this.l10n});

  final UserEsim esim;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usage = esim.usage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: usage == null
          ? Column(
              children: [
                Text(l10n.esimUsageTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Text(
                  l10n.esimUsageUnavailable,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
              ],
            )
          : Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(l10n.esimUsageTitle, style: theme.textTheme.titleMedium),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: usage.isUnlimited ? 1 : usage.remainingFraction,
                          strokeWidth: 12,
                          backgroundColor: AppColors.surfaceMuted,
                          color: AppColors.primary,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            usage.isUnlimited
                                ? l10n.esimUnlimited
                                : '${usage.percentUsed.toStringAsFixed(usage.percentUsed >= 10 ? 0 : 1)}%',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            usage.isUnlimited ? l10n.esimDataLeft : l10n.esimUsed,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (usage.isUnlimited)
                  Text(
                    l10n.esimUnlimitedHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          label: l10n.esimUsed,
                          value: formatDataMb(usage.usedMb),
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          label: l10n.esimRemaining,
                          value: formatDataMb(usage.remainingMb),
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          label: l10n.esimTotal,
                          value: formatDataMb(usage.totalMb),
                        ),
                      ),
                    ],
                  ),
                if (usage.totalVoice > 0 || usage.totalText > 0) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  if (usage.totalVoice > 0)
                    Text(
                      l10n.esimVoiceLeft(usage.remainingVoice, usage.totalVoice),
                      style: theme.textTheme.bodySmall,
                    ),
                  if (usage.totalText > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.esimSmsLeft(usage.remainingText, usage.totalText),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ],
            ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }
}

class _IosInstallPanel extends StatelessWidget {
  const _IosInstallPanel({
    required this.esim,
    required this.l10n,
    required this.onOpenApple,
    required this.onCopy,
  });

  final UserEsim esim;
  final AppLocalizations l10n;
  final VoidCallback onOpenApple;
  final void Function(String label, String value) onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (esim.appleInstallUrl != null && esim.appleInstallUrl!.isNotEmpty) ...[
          PrimaryButton(
            label: l10n.esimInstallOnIphone,
            icon: Icons.phone_iphone_rounded,
            onPressed: onOpenApple,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.esimInstallOnIphoneHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
        ],
        if (esim.qrcodeUrl != null && esim.qrcodeUrl!.isNotEmpty)
          _QrCard(url: esim.qrcodeUrl!, label: l10n.esimScanQr),
        const SizedBox(height: 14),
        _StepsCard(
          title: l10n.esimStepsIphoneTitle,
          steps: [
            l10n.esimStepIphone1,
            l10n.esimStepIphone2,
            l10n.esimStepIphone3,
            l10n.esimStepIphone4,
          ],
        ),
      ],
    );
  }
}

class _AndroidInstallPanel extends StatelessWidget {
  const _AndroidInstallPanel({
    required this.esim,
    required this.l10n,
    required this.onCopy,
    required this.onOpenShare,
  });

  final UserEsim esim;
  final AppLocalizations l10n;
  final void Function(String label, String value) onCopy;
  final VoidCallback onOpenShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (esim.qrcodeUrl != null && esim.qrcodeUrl!.isNotEmpty) ...[
          _QrCard(url: esim.qrcodeUrl!, label: l10n.esimScanQr),
          const SizedBox(height: 14),
        ],
        _StepsCard(
          title: l10n.esimStepsAndroidTitle,
          steps: [
            l10n.esimStepAndroid1,
            l10n.esimStepAndroid2,
            l10n.esimStepAndroid3,
            l10n.esimStepAndroid4,
          ],
        ),
      ],
    );
  }
}

class _ManualCodesCard extends StatelessWidget {
  const _ManualCodesCard({
    required this.esim,
    required this.l10n,
    required this.onCopy,
  });

  final UserEsim esim;
  final AppLocalizations l10n;
  final void Function(String label, String value) onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.esimManualTitle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            l10n.esimManualSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          if (esim.smdpAddress != null && esim.smdpAddress!.isNotEmpty)
            _CopyField(
              label: l10n.esimSmdpAddress,
              value: esim.smdpAddress!,
              onCopy: () => onCopy(l10n.esimSmdpAddress, esim.smdpAddress!),
            ),
          if (esim.activationCode != null && esim.activationCode!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CopyField(
              label: l10n.esimActivationCode,
              value: esim.activationCode!,
              onCopy: () => onCopy(l10n.esimActivationCode, esim.activationCode!),
            ),
          ],
          const SizedBox(height: 10),
          if (esim.confirmationCode != null && esim.confirmationCode!.isNotEmpty)
            _CopyField(
              label: l10n.esimConfirmationCode,
              value: esim.confirmationCode!,
              onCopy: () => onCopy(l10n.esimConfirmationCode, esim.confirmationCode!),
            )
          else
            _Note(text: l10n.esimConfirmationOptional),
          if (esim.iccid.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CopyField(
              label: 'ICCID',
              value: esim.iccid,
              onCopy: () => onCopy('ICCID', esim.iccid),
            ),
          ],
        ],
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  const _QrCard({required this.url, required this.label});

  final String url;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                width: 220,
                height: 220,
                color: AppColors.surfaceMuted,
                alignment: Alignment.center,
                child: const Icon(Icons.qr_code_2_rounded, size: 72, color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyField extends StatelessWidget {
  const _CopyField({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy_rounded, size: 18, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.title, required this.steps});

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    steps[i],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
      ),
    );
  }
}
