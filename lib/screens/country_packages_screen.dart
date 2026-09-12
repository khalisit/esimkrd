import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../config/regional_countries.dart';
import '../models/country.dart';
import '../models/package.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/country_names.dart';
import '../utils/api_errors.dart';
import '../utils/page_transitions.dart';
import '../utils/payment_flow.dart';
import '../services/analytics_service.dart';
import '../services/deep_link_service.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/glow_background.dart';
import '../widgets/error_state_view.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/package_tile.dart';
import '../widgets/payment_method_sheet.dart';
import 'login_screen.dart';

class CountryPackagesScreen extends StatefulWidget {
  const CountryPackagesScreen({
    super.key,
    required this.api,
    required this.country,
  });

  final ApiClient api;
  final Country country;

  @override
  State<CountryPackagesScreen> createState() => _CountryPackagesScreenState();
}

class _CountryPackagesScreenState extends State<CountryPackagesScreen> {
  late Future<List<EsimPackage>> _packagesFuture;
  int? _buyingPackageId;
  _PlanDataFilter _planFilter = _PlanDataFilter.all;

  @override
  void initState() {
    super.initState();
    _packagesFuture = _loadPackages();
  }

  Future<List<EsimPackage>> _loadPackages() async {
    final apiCountry = RegionalCountries.packageCountryCode(widget.country.code);
    final response = await widget.api.get(
      '/packages?country=$apiCountry',
    );
    final list = response['data'] as List<dynamic>;
    return list
        .map((e) => EsimPackage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  bool _isUnlimited(EsimPackage package) =>
      package.dataAmount?.toLowerCase() == 'unlimited';

  List<EsimPackage> _filterPackages(List<EsimPackage> packages) {
    switch (_planFilter) {
      case _PlanDataFilter.limited:
        return packages.where((p) => !_isUnlimited(p)).toList();
      case _PlanDataFilter.unlimited:
        return packages.where((p) => _isUnlimited(p)).toList();
      case _PlanDataFilter.all:
        return packages;
    }
  }

  Future<void> _buyPackage(EsimPackage package) async {
    final l10n = AppLocalizations.of(context)!;

    if (!widget.api.isLoggedIn) {
      if (!mounted) return;
      await Navigator.of(context).push<bool>(
        AppPageRoute(page: LoginScreen(api: widget.api)),
      );
      if (!mounted || !widget.api.isLoggedIn) return;
    }

    setState(() => _buyingPackageId = package.id);

    final localeCode = Localizations.localeOf(context).languageCode;
    final initialPromo = await DeepLinkService.getPendingPromoCode();
    if (!mounted) {
      setState(() => _buyingPackageId = null);
      return;
    }

    final paymentMethod = await PaymentMethodSheet.show(
      context,
      package: package,
      api: widget.api,
      initialPromoCode: initialPromo,
    );
    if (!mounted || paymentMethod == null) {
      setState(() => _buyingPackageId = null);
      return;
    }

    try {
      AnalyticsService.logPurchaseStarted(
        packageId: package.id,
        countryCode: package.countryCode,
      );

      final response = await widget.api.post(
        '/orders',
        body: {
          'package_id': package.id,
          'language': paymentLanguageForLocale(localeCode),
          'payment_method': paymentMethod.paymentMethod,
          if (paymentMethod.promoCode != null) 'promo_code': paymentMethod.promoCode,
        },
        auth: true,
      );
      if (paymentMethod.promoCode != null) {
        await DeepLinkService.clearPendingPromoCode();
        AnalyticsService.logPromoApplied(paymentMethod.promoCode!);
      }
      if (!mounted) return;

      final data = response['data'] as Map<String, dynamic>?;
      final paymentUrl = data?['payment_url'] as String?;
      final gateway = (data?['payment'] as Map<String, dynamic>?)?['gateway'] as String?;

      if ((paymentUrl != null && paymentUrl.isNotEmpty) || gateway == 'fib') {
        await startCheckoutFlow(context: context, api: widget.api, orderResponse: response);
        final order = (response['data'] as Map<String, dynamic>?)?['order'] as Map<String, dynamic>?;
        final orderId = order?['id'] as int?;
        if (orderId != null) {
          AnalyticsService.logPurchaseCompleted(orderId: orderId);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.orderCreated)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formatApiError(l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _buyingPackageId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countryName = CountryNames.localized(
      context,
      widget.country.code,
      widget.country.name,
    );

    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: FutureBuilder<List<EsimPackage>>(
            future: _packagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PackageListSkeleton();
              }
              if (snapshot.hasError) {
                return ErrorStateView(
                  title: isNetworkError(snapshot.error!)
                      ? l10n.offlineTitle
                      : l10n.apiError,
                  message: formatApiError(l10n, snapshot.error!),
                  retryLabel: l10n.retry,
                  onRetry: () => setState(() => _packagesFuture = _loadPackages()),
                  icon: isNetworkError(snapshot.error!)
                      ? Icons.wifi_off_rounded
                      : Icons.cloud_off_rounded,
                );
              }

              final allPackages = snapshot.data ?? [];
              if (allPackages.isEmpty) {
                return Center(child: Text(l10n.noPackages));
              }

              final packages = _filterPackages(allPackages);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: _CountryHeroBanner(
                      country: widget.country,
                      countryName: countryName,
                      count: allPackages.length,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l10n.plansAvailable(packages.length),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _PlanFilterRow(
                            selected: _planFilter,
                            onChanged: (filter) => setState(() => _planFilter = filter),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (packages.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.noResults,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverList.separated(
                        itemCount: packages.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final pkg = packages[index];
                          return FadeSlideIn(
                            delay: Duration(milliseconds: 45 * index.clamp(0, 8)),
                            child: PackageTile(
                              package: pkg,
                              buying: _buyingPackageId == pkg.id,
                              onBuy: () => _buyPackage(pkg),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

enum _PlanDataFilter { all, limited, unlimited }

class _PlanFilterRow extends StatelessWidget {
  const _PlanFilterRow({
    required this.selected,
    required this.onChanged,
  });

  final _PlanDataFilter selected;
  final ValueChanged<_PlanDataFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _PlanFilterChip(
            label: l10n.filterAll,
            icon: Icons.grid_view_rounded,
            selected: selected == _PlanDataFilter.all,
            onTap: () => onChanged(_PlanDataFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PlanFilterChip(
            label: l10n.filterLimited,
            icon: Icons.cell_tower_rounded,
            selected: selected == _PlanDataFilter.limited,
            onTap: () => onChanged(_PlanDataFilter.limited),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PlanFilterChip(
            label: l10n.unlimited,
            icon: Icons.all_inclusive_rounded,
            selected: selected == _PlanDataFilter.unlimited,
            onTap: () => onChanged(_PlanDataFilter.unlimited),
          ),
        ),
      ],
    );
  }
}

class _PlanFilterChip extends StatelessWidget {
  const _PlanFilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.45)
                  : AppColors.border,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? AppColors.primaryDark : AppColors.textSecondary,
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

class _CountryHeroBanner extends StatelessWidget {
  const _CountryHeroBanner({
    required this.country,
    required this.countryName,
    required this.count,
    required this.onBack,
  });

  final Country country;
  final String countryName;
  final int count;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
              ),
              const Spacer(),
              CountryFlagBadge(
                countryCode: country.code,
                countryName: country.name,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.surface,
                  AppColors.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CountryFlagAvatar(
                        countryCode: country.code,
                        countryName: country.name,
                        size: 72,
                        borderRadius: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            countryName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              l10n.plansAvailable(count),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 20,
                        color: AppColors.primary.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.countryHeroDesc,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                height: 1.35,
                              ),
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
    );
  }
}
