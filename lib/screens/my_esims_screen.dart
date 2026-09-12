import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/user_esim.dart';
import '../services/api_client.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../utils/api_errors.dart';
import '../utils/page_transitions.dart';
import '../widgets/app_card.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/error_state_view.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/primary_button.dart';
import 'esim_detail_screen.dart';

class MyEsimsScreen extends StatefulWidget {
  const MyEsimsScreen({
    super.key,
    required this.api,
    required this.onGoStore,
    required this.onLogin,
    this.onSessionExpired,
  });

  final ApiClient api;
  final VoidCallback onGoStore;
  final VoidCallback onLogin;
  final VoidCallback? onSessionExpired;

  @override
  State<MyEsimsScreen> createState() => MyEsimsScreenState();
}

class MyEsimsScreenState extends State<MyEsimsScreen> {
  Future<List<UserEsim>>? _esimsFuture;

  @override
  void initState() {
    super.initState();
    _esimsFuture = _loadEsims();
  }

  void refresh() {
    setState(() {
      _esimsFuture = _loadEsims();
    });
  }

  Future<List<UserEsim>> _loadEsims() async {
    if (!widget.api.isLoggedIn) return [];

    try {
      final response = await widget.api.get('/my-esims', auth: true);
      final list = response['data'] as List<dynamic>;
      final esims = list.map((e) => UserEsim.fromJson(e as Map<String, dynamic>)).toList();
      
      _checkNotifications(esims);

      return esims;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        widget.onSessionExpired?.call();
      }
      rethrow;
    }
  }

  void _checkNotifications(List<UserEsim> esims) {
    for (final esim in esims) {
      if (esim.status != 'active') continue;

      if (esim.usage != null && !esim.usage!.isUnlimited) {
        if (esim.usage!.remainingMb > 0 && esim.usage!.remainingMb <= 500) {
          NotificationService().showLowDataNotification(esim.packageName, esim.iccid);
        }
      }

      if (esim.expiresAt != null) {
        NotificationService().scheduleExpiryNotification(esim.packageName, esim.expiresAt!, esim.iccid);
      }
    }
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    return switch (status) {
      'active' => l10n.statusActive,
      'expired' => l10n.statusExpired,
      'depleted' => l10n.statusDepleted,
      _ => status,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'active' => AppColors.success,
      'expired' => AppColors.textMuted,
      'depleted' => AppColors.error,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget buildHeader() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeSlideIn(
              child: Text(
                l10n.myEsimsTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      );
    }

    if (!widget.api.isLoggedIn) {
      return SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(child: buildHeader()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: _GuestState(l10n: l10n, onLogin: widget.onLogin),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: FutureBuilder<List<UserEsim>>(
        future: _esimsFuture,
        builder: (context, snapshot) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              refresh();
              try {
                await _esimsFuture;
              } catch (_) {}
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(child: buildHeader()),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverToBoxAdapter(
                    child: EsimListSkeleton(),
                  )
                else if (snapshot.hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorStateView(
                      title: isNetworkError(snapshot.error!)
                          ? l10n.offlineTitle
                          : l10n.apiError,
                      message: formatApiError(l10n, snapshot.error!),
                      retryLabel: l10n.retry,
                      onRetry: refresh,
                      icon: isNetworkError(snapshot.error!)
                          ? Icons.wifi_off_rounded
                          : Icons.cloud_off_rounded,
                    ),
                  )
                else if (snapshot.data == null || snapshot.data!.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(l10n: l10n, onGoStore: widget.onGoStore),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      NavIslandLayout.bottomClearance(context),
                    ),
                    sliver: SliverList.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final esim = snapshot.data![index];
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 50 * index.clamp(0, 8)),
                          child: _EsimCard(
                            esim: esim,
                            statusLabel: _statusLabel(l10n, esim.status),
                            statusColor: _statusColor(esim.status),
                            l10n: l10n,
                            onTap: () async {
                              await Navigator.of(context).push(
                                AppPageRoute(
                                  page: EsimDetailScreen(api: widget.api, esim: esim),
                                ),
                              );
                              if (mounted) refresh();
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EsimCard extends StatelessWidget {
  const _EsimCard({
    required this.esim,
    required this.statusLabel,
    required this.statusColor,
    required this.l10n,
    required this.onTap,
  });

  final UserEsim esim;
  final String statusLabel;
  final Color statusColor;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final expires = esim.expiresAt != null
        ? '${esim.expiresAt!.year}-${esim.expiresAt!.month.toString().padLeft(2, '0')}-${esim.expiresAt!.day.toString().padLeft(2, '0')}'
        : '—';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (esim.countryCode != null && esim.countryCode!.isNotEmpty)
                CountryFlagAvatar(
                  countryCode: esim.countryCode!.toUpperCase() == 'IQ' ? 'KRD' : esim.countryCode!,
                  size: 44,
                  borderRadius: 12,
                )
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sim_card_rounded, color: AppColors.primary),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  esim.packageName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (esim.usage != null && !esim.usage!.isUnlimited && esim.usage!.totalMb > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 1 - esim.usage!.remainingFraction,
                minHeight: 8,
                backgroundColor: AppColors.surfaceMuted,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.esimUsageSummary(
                formatDataMb(esim.usage!.usedMb),
                formatDataMb(esim.usage!.totalMb),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ] else ...[
            Text(
              l10n.dataUsage(esim.dataUsed ?? '0', esim.dataTotal ?? '—'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 4),
          Text(
            l10n.expiresOn(expires),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.insights_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.esimTapToInstall,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuestState extends StatelessWidget {
  const _GuestState({required this.l10n, required this.onLogin});

  final AppLocalizations l10n;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.7)),
              const SizedBox(height: 16),
              Text(l10n.myEsimsLogin, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              PrimaryButton(label: l10n.login, icon: Icons.login_rounded, onPressed: onLogin),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n, required this.onGoStore});

  final AppLocalizations l10n;
  final VoidCallback onGoStore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sim_card_download_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(l10n.myEsimsEmpty, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              PrimaryButton(
                label: l10n.myEsimsGoStore,
                icon: Icons.storefront_rounded,
                onPressed: onGoStore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
