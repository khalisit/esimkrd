import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

abstract final class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> _safeLogEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (kIsWeb) return;
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e, stack) {
      debugPrint('Analytics $name failed: $e\n$stack');
    }
  }

  static Future<void> logScreen(String name) async {
    if (kIsWeb) return;
    try {
      await _analytics.logScreenView(screenName: name);
    } catch (e, stack) {
      debugPrint('Analytics screen view failed: $e\n$stack');
    }
  }

  static Future<void> logPurchaseStarted({
    required int packageId,
    required String countryCode,
    bool isTopUp = false,
  }) async {
    await _safeLogEvent(
      'purchase_started',
      parameters: {
        'package_id': packageId,
        'country_code': countryCode,
        'is_topup': isTopUp ? 1 : 0,
      },
    );
  }

  static Future<void> logPurchaseCompleted({required int orderId}) async {
    await _safeLogEvent(
      'purchase_completed',
      parameters: {'order_id': orderId},
    );
  }

  static Future<void> logPromoApplied(String code) async {
    await _safeLogEvent('promo_applied', parameters: {'code': code});
  }

  static Future<void> logReferralShared(String code) async {
    await _safeLogEvent('referral_shared', parameters: {'code': code});
  }
}
