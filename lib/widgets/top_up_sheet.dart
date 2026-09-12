import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/package.dart';
import '../models/user_esim.dart';
import '../screens/login_screen.dart';
import '../services/api_client.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import '../theme/app_colors.dart';
import '../utils/api_errors.dart';
import '../utils/currency_format.dart';
import '../utils/page_transitions.dart';
import '../utils/payment_flow.dart';
import '../widgets/payment_method_sheet.dart';
class TopUpSheet extends StatefulWidget {
  const TopUpSheet({
    super.key,
    required this.api,
    required this.esim,
  });

  final ApiClient api;
  final UserEsim esim;

  static Future<void> show(BuildContext context, {required ApiClient api, required UserEsim esim}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TopUpSheet(api: api, esim: esim),
    );
  }

  @override
  State<TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<TopUpSheet> {
  late Future<List<EsimPackage>> _packagesFuture;
  int? _buyingId;

  @override
  void initState() {
    super.initState();
    _packagesFuture = _loadPackages();
  }

  Future<List<EsimPackage>> _loadPackages() async {
    final response = await widget.api.get('/my-esims/${widget.esim.id}/top-up-packages', auth: true);
    final list = response['data'] as List<dynamic>;
    return list.map((e) => EsimPackage.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _buy(EsimPackage package) async {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.api.isLoggedIn) {
      await Navigator.of(context).push<bool>(AppPageRoute(page: LoginScreen(api: widget.api)));
      if (!mounted || !widget.api.isLoggedIn) return;
    }

    setState(() => _buyingId = package.id);

    final localeCode = Localizations.localeOf(context).languageCode;
    final initialPromo = await DeepLinkService.getPendingPromoCode();
    if (!mounted) {
      setState(() => _buyingId = null);
      return;
    }

    final selection = await PaymentMethodSheet.show(
      context,
      package: package,
      api: widget.api,
      initialPromoCode: initialPromo,
    );

    if (!mounted || selection == null) {
      setState(() => _buyingId = null);
      return;
    }

    try {
      AnalyticsService.logPurchaseStarted(
        packageId: package.id,
        countryCode: package.countryCode,
        isTopUp: true,
      );

      final response = await widget.api.post(
        '/orders',
        body: {
          'package_id': package.id,
          'user_esim_id': widget.esim.id,
          'language': paymentLanguageForLocale(localeCode),
          'payment_method': selection.paymentMethod,
          if (selection.promoCode != null) 'promo_code': selection.promoCode,
        },
        auth: true,
      );

      if (selection.promoCode != null) {
        await DeepLinkService.clearPendingPromoCode();
        AnalyticsService.logPromoApplied(selection.promoCode!);
      }

      if (!mounted) return;
      await startCheckoutFlow(context: context, api: widget.api, orderResponse: response);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(formatApiError(l10n, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _buyingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom > 0 ? 0 : 8),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.topUpTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              l10n.topUpSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<EsimPackage>>(
              future: _packagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final packages = snapshot.data ?? [];
                if (packages.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.noPackages, textAlign: TextAlign.center),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: packages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    final loading = _buyingId == pkg.id;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      title: Text(pkg.title),
                      subtitle: Text(
                        [
                          if (pkg.dataAmount != null) pkg.dataAmount!,
                          if (pkg.validityDays > 0) '${pkg.validityDays} days',
                        ].join(' · '),
                      ),
                      trailing: loading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(
                              CurrencyFormat.usd(pkg.retailPriceUsd),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      onTap: loading ? null : () => _buy(pkg),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
