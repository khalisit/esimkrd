import '../models/user_esim.dart';

enum EsimAlertType { lowData, expirySoon }

class EsimAlertInfo {
  const EsimAlertInfo({
    required this.type,
    required this.titleKey,
    required this.messageKey,
    this.daysLeft,
    this.percentLeft,
  });

  final EsimAlertType type;
  final String titleKey;
  final String messageKey;
  final int? daysLeft;
  final int? percentLeft;
}

abstract final class EsimAlerts {
  static const lowDataThreshold = 0.10;
  static const expiryWarningDays = 3;

  static List<EsimAlertInfo> forEsim(UserEsim esim) {
    final alerts = <EsimAlertInfo>[];
    final lowData = _lowDataAlert(esim.usage);
    if (lowData != null) alerts.add(lowData);

    final expiry = _expiryAlert(esim.expiresAt, esim.usage?.expiredAt, esim.status);
    if (expiry != null) alerts.add(expiry);

    return alerts;
  }

  static EsimAlertInfo? _lowDataAlert(EsimUsage? usage) {
    if (usage == null || usage.isUnlimited || usage.totalMb <= 0) return null;
    if (usage.remainingFraction > lowDataThreshold) return null;

    final percentLeft = (usage.remainingFraction * 100).round().clamp(0, 100);
    return EsimAlertInfo(
      type: EsimAlertType.lowData,
      titleKey: 'lowData',
      messageKey: 'lowData',
      percentLeft: percentLeft,
    );
  }

  static EsimAlertInfo? _expiryAlert(
    DateTime? expiresAt,
    DateTime? usageExpiredAt,
    String status,
  ) {
    if (status == 'expired' || status == 'depleted') return null;

    final expiry = expiresAt ?? usageExpiredAt;
    if (expiry == null) return null;

    final daysLeft = expiry.difference(DateTime.now()).inDays;
    if (daysLeft < 0) return null;
    if (daysLeft > expiryWarningDays) return null;

    return EsimAlertInfo(
      type: EsimAlertType.expirySoon,
      titleKey: 'expirySoon',
      messageKey: 'expirySoon',
      daysLeft: daysLeft,
    );
  }
}
