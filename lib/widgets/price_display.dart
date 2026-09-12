import 'package:flutter/material.dart';

import '../services/currency_preference_service.dart';
import '../theme/app_colors.dart';
import '../utils/currency_format.dart';

/// Shows USD/IQD prices according to the user's currency preference.
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    super.key,
    required this.amountUsd,
    this.amountIqd,
    this.primaryStyle,
    this.secondaryStyle,
    this.crossAxisAlignment = CrossAxisAlignment.end,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final double amountUsd;
  final int? amountIqd;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryStyle ??
        theme.textTheme.headlineSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        );
    final secondary = secondaryStyle ??
        theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted);

    return ListenableBuilder(
      listenable: CurrencyPreferenceService.instance,
      builder: (context, _) {
        final lines = CurrencyFormat.lines(
          usd: amountUsd,
          iqd: amountIqd,
        );

        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            for (var i = 0; i < lines.length; i++)
              Text(
                lines[i],
                style: i == 0 ? primary : secondary,
              ),
          ],
        );
      },
    );
  }
}
