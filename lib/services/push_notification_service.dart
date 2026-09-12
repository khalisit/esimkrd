import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import 'api_client.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('FCM background: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService(this._api);

  final ApiClient _api;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Called when user taps a notification (foreground/background).
  void Function(Map<String, dynamic> data)? onNotificationOpened;

  /// Fast startup — listeners only; no permission dialog or APNS wait.
  Future<void> init() async {
    if (kIsWeb) return;
    if (Firebase.apps.isEmpty) {
      debugPrint('FCM: Firebase not initialized — skipping push setup');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _messaging.onTokenRefresh.listen((token) async {
      if (_api.isLoggedIn) {
        await _sendToken(token);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handleMessage(initial);
    }
  }

  /// Deferred after first frame — permission + token registration.
  Future<void> setupAfterLaunch() async {
    if (kIsWeb || Firebase.apps.isEmpty) return;

    await _requestPermission();
    await _registerToken();
  }

  Future<void> registerAfterLogin() async {
    if (kIsWeb) return;
    await _registerToken();
  }

  Future<void> unregister() async {
    if (kIsWeb) return;
    try {
      await _api.delete('/auth/fcm-token', auth: true);
    } catch (_) {}
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM permission: ${settings.authorizationStatus}');

    if (!kIsWeb && Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _registerToken() async {
    if (!kIsWeb && Platform.isIOS) {
      await _waitForApnsToken();
    }

    final token = await _messaging.getToken();
    if (token != null && _api.isLoggedIn) {
      await _sendToken(token);
    } else if (token == null) {
      debugPrint('FCM: token is null — check Firebase iOS setup / GoogleService-Info.plist');
    }
  }

  Future<void> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 8; attempt++) {
      final apns = await _messaging.getAPNSToken();
      if (apns != null) {
        debugPrint('FCM: APNS token ready');
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }

    debugPrint('FCM: APNS token not available yet — will retry on token refresh');
  }

  Future<void> _sendToken(String token) async {
    try {
      await _api.post('/auth/fcm-token', body: {'token': token}, auth: true);
      debugPrint('FCM token registered');
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('FCM opened: ${message.data}');
    if (message.data.isNotEmpty) {
      onNotificationOpened?.call(message.data);
    }
  }
}
