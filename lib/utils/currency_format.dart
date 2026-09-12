import 'package:intl/intl.dart';

import '../config/app_config.dart';import '../services/currency_preference_service.dart';

abstract final class CurrencyFormat {
  static CurrencyDisplayMode displayMode = CurrencyDisplayMode.both;

  static String usd(double amount) => '\$${amount.toStringAsFixed(2)}';

  static String iqd(int amount) {
    final formatted = NumberFormat('#,###', 'en').format(amount);
    return '$formatted IQD';
  }
  static int iqdFromUsd(double usd) =>
      (usd * AppConfig.usdToIqd).round();

  static List<String> lines({
    required double usd,
    int? iqd,
  }) {
    final resolvedIqd = iqd ?? iqdFromUsd(usd);
    final mode = CurrencyPreferenceService.instance.mode;

    return switch (mode) {
      CurrencyDisplayMode.usd => [CurrencyFormat.usd(usd)],
      CurrencyDisplayMode.iqd => [CurrencyFormat.iqd(resolvedIqd)],
      CurrencyDisplayMode.both => [
          CurrencyFormat.usd(usd),
          CurrencyFormat.iqd(resolvedIqd),
        ],
    };
  }
}
