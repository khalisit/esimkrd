import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/order_summary.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../utils/api_errors.dart';
import '../services/currency_preference_service.dart';
import '../utils/currency_format.dart';
import '../utils/payment_flow.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/app_card.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/error_state_view.dart';
import '../widgets/primary_button.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.api});

  final ApiClient api;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<OrderSummary>>? _ordersFuture;
  int? _resumingOrderId;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<List<OrderSummary>> _loadOrders() async {
    final response = await widget.api.get('/orders', auth: true);
    final raw = response['data'];
    if (raw is! List) return [];

    final orders = <OrderSummary>[];
    for (final item in raw) {
      if (item is! Map) continue;
      try {
        orders.add(
          OrderSummary.fromJson(Map<String, dynamic>.from(item)),
        );
      } catch (_) {
        // Skip malformed rows instead of failing the whole screen.
      }
    }
    return orders;
  }

  void _refresh() {
    setState(() => _ordersFuture = _loadOrders());
  }

  String _statusLabel(AppLocalizations l10n, OrderSummary order) {
    if (order.status == 'pending' &&
        order.paymentGateway == 'fib_manual' &&
        order.paymentStatus == 'submitted') {
      return l10n.orderAwaitingVerification;
    }

    return switch (order.status) {
      'pending' => l10n.orderStatusPending,
      'paid' => l10n.orderStatusPaid,
      'processing' => l10n.orderStatusProcessing,
      'completed' => l10n.orderStatusCompleted,
      'failed' => l10n.orderStatusFailed,
      _ => order.status,
    };
  }

  Color _statusColor(OrderSummary order) {
    if (order.status == 'pending' &&
        order.paymentGateway == 'fib_manual' &&
        order.paymentStatus == 'submitted') {
      return AppColors.warning;
    }

    return switch (order.status) {
      'pending' => AppColors.warning,
      'paid' || 'processing' => AppColors.primary,
      'completed' => AppColors.success,
      'failed' => AppColors.error,
      _ => AppColors.textMuted,
    };
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }

  Future<void> _resumePayment(OrderSummary order) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _resumingOrderId = order.id);

    try {
      await resumeCheckoutFlow(
        context: context,
        api: widget.api,
        orderId: order.id,
      );
      if (mounted) _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _resumingOrderId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.orderHistoryTitle),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
          await _ordersFuture;
        },
        child: FutureBuilder<List<OrderSummary>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 280,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ErrorStateView(
                    title: isNetworkError(snapshot.error!)
                        ? l10n.offlineTitle
                        : l10n.apiError,
                    message: formatApiError(l10n, snapshot.error!),
                    retryLabel: l10n.retry,
                    onRetry: _refresh,
                    icon: isNetworkError(snapshot.error!)
                        ? Icons.wifi_off_rounded
                        : Icons.cloud_off_rounded,
                  ),
                ],
              );
            }

            final orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 56,
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.orderHistoryEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                NavIslandLayout.bottomClearance(context),
              ),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(
                  order: order,
                  statusLabel: _statusLabel(l10n, order),
                  statusColor: _statusColor(order),
                  dateLabel: _formatDate(order.createdAt),
                  resumeLabel: l10n.completePayment,
                  resuming: _resumingOrderId == order.id,
                  onResume: order.canResumePayment
                      ? () => _resumePayment(order)
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.statusLabel,
    required this.statusColor,
    required this.dateLabel,
    required this.resumeLabel,
    required this.resuming,
    this.onResume,
  });

  final OrderSummary order;
  final String statusLabel;
  final Color statusColor;
  final String dateLabel;
  final String resumeLabel;
  final bool resuming;
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      if (order.dataAmount != null && order.dataAmount!.isNotEmpty) order.dataAmount!,
      if (order.validityDays > 0) '${order.validityDays} days',
    ].join(' · ');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CountryFlagAvatar(
                countryCode: order.countryCode.toUpperCase() == 'IQ' ? 'KRD' : order.countryCode,
                countryName: order.countryName,
                size: 44,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.packageTitle.isNotEmpty
                          ? order.packageTitle
                          : order.countryName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        meta,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.orderNumber(order.id),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              if (dateLabel.isNotEmpty) ...[
                const Text(' · ', style: TextStyle(color: AppColors.textMuted)),
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: CurrencyPreferenceService.instance,
            builder: (context, _) {
              final prices = CurrencyFormat.lines(
                usd: order.amountUsd,
                iqd: order.amountIqd,
              ).join(' · ');

              return Text(
                prices,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          if (onResume != null) ...[
            const SizedBox(height: 14),
            PrimaryButton(
              label: resumeLabel,
              icon: Icons.payment_rounded,
              loading: resuming,
              onPressed: resuming ? null : onResume,
            ),
          ],
        ],
      ),
    );
  }
}
