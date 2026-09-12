import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DeepLinkActionType { order, esim, referral, promo, paymentSuccess, paymentCancel }

class DeepLinkAction {
  const DeepLinkAction({required this.type, this.id, this.code});

  final DeepLinkActionType type;
  final int? id;
  final String? code;
}

/// Handles esimkrd:// deep links and stores pending promo/referral codes.
class DeepLinkService extends ChangeNotifier {
  static const _promoKey = 'pending_promo_code';
  static const _referralKey = 'pending_referral_code';

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  DeepLinkAction? _pendingAction;

  DeepLinkAction? get pendingAction => _pendingAction;

  Future<void> init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        _handleUri(initial);
      }
      _subscription = _appLinks.uriLinkStream.listen(_handleUri);
    } catch (e) {
      debugPrint('DeepLinkService init error: $e');
    }
  }

  void _handleUri(Uri uri) {
    if (uri.scheme != 'esimkrd') return;

    switch (uri.host) {
      case 'payment':
        final path = uri.path;
        if (path.startsWith('/success')) {
          final orderId = int.tryParse(uri.queryParameters['order_id'] ?? '');
          _pendingAction = DeepLinkAction(
            type: DeepLinkActionType.paymentSuccess,
            id: orderId,
          );
        } else if (path.startsWith('/cancel')) {
          _pendingAction = const DeepLinkAction(type: DeepLinkActionType.paymentCancel);
        }
        break;
      case 'order':
        final id = int.tryParse(uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '');
        if (id != null) {
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.order, id: id);
        }
        break;
      case 'esim':
        final id = int.tryParse(uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '');
        if (id != null) {
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.esim, id: id);
        }
        break;
      case 'referral':
        final code = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        if (code != null && code.isNotEmpty) {
          _saveReferralCode(code);
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.referral, code: code);
        }
        break;
      case 'promo':
        final code = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        if (code != null && code.isNotEmpty) {
          _savePromoCode(code);
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.promo, code: code);
        }
        break;
    }

    notifyListeners();
  }

  void clearPendingAction() {
    _pendingAction = null;
    notifyListeners();
  }

  /// Map FCM data payload (route, esim_id, …) to in-app navigation.
  void handlePushData(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    if (route == null) return;

    switch (route) {
      case 'esim':
        final id = int.tryParse(data['esim_id']?.toString() ?? '');
        if (id != null) {
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.esim, id: id);
          notifyListeners();
        }
        break;
      case 'order':
        final id = int.tryParse(data['order_id']?.toString() ?? '');
        if (id != null) {
          _pendingAction = DeepLinkAction(type: DeepLinkActionType.order, id: id);
          notifyListeners();
        }
        break;
    }
  }

  Future<void> _savePromoCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_promoKey, code.toUpperCase());
  }

  Future<void> _saveReferralCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_referralKey, code.toUpperCase());
  }

  static Future<String?> getPendingPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_promoKey);
  }

  static Future<String?> getPendingReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_referralKey);
  }

  static Future<void> clearPendingPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_promoKey);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
