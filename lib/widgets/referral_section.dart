import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../services/analytics_service.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

class ReferralSection extends StatefulWidget {
  const ReferralSection({super.key, required this.api, this.compact = false});

  final ApiClient api;
  final bool compact;

  @override
  State<ReferralSection> createState() => _ReferralSectionState();
}

class _ReferralSectionState extends State<ReferralSection> {
  Future<Map<String, dynamic>>? _future;

  @override
  void initState() {
    super.initState();
    if (widget.api.isLoggedIn) {
      _future = _load();
    }
  }

  Future<Map<String, dynamic>> _load() async {
    final response = await widget.api.get('/referrals/me', auth: true);
    return response['data'] as Map<String, dynamic>;
  }

  Future<void> _share(String code, String link, AppLocalizations l10n) async {
    AnalyticsService.logReferralShared(code);
    await SharePlus.instance.share(
      ShareParams(
        text: '${l10n.referralShareMessage(code)}\n$link',
        subject: l10n.referralTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.api.isLoggedIn) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<Map<String, dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final data = snapshot.data!;
        final code = data['code'] as String? ?? '';
        final link = data['link'] as String? ?? 'esimkrd://referral/$code';
        final count = data['referrals_count'] as int? ?? 0;

        if (widget.compact) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 20),
            ),
            title: Text(l10n.referralTitle),
            subtitle: Text(
              '$code · ${l10n.referralCount(count)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: IconButton(
              onPressed: () => _share(code, link, l10n),
              icon: const Icon(Icons.ios_share_rounded, size: 20),
              color: AppColors.primary,
              tooltip: l10n.referralShare,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.referralTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.referralSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      code,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    l10n.referralCount(count),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: l10n.referralShare,
              icon: Icons.ios_share_rounded,
              onPressed: () => _share(code, link, l10n),
            ),
          ],
        );
      },
    );
  }
}
