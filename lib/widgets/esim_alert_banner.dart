import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/esim_alerts.dart';

class EsimAlertBanner extends StatelessWidget {
  const EsimAlertBanner({super.key, required this.alert});

  final EsimAlertInfo alert;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLowData = alert.type == EsimAlertType.lowData;
    final color = isLowData ? AppColors.warning : AppColors.primary;

    final title = isLowData
        ? l10n.esimLowDataTitle
        : l10n.esimExpirySoonTitle;
    final message = isLowData
        ? l10n.esimLowDataMessage(alert.percentLeft ?? 0)
        : l10n.esimExpirySoonMessage(alert.daysLeft ?? 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isLowData ? Icons.data_usage_rounded : Icons.schedule_rounded,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
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
