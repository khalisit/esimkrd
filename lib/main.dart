import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/app_config.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'l10n/ku_localizations_fallback.dart';
import 'screens/main_shell_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/api_client.dart';
import 'services/connectivity_service.dart';
import 'services/currency_preference_service.dart';
import 'services/deep_link_service.dart';
import 'services/locale_service.dart';
import 'services/onboarding_service.dart';
import 'services/push_notification_service.dart';
import 'services/notification_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'widgets/keyboard_dismisser.dart';

enum _AppPhase { onboarding, home }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    if (!kIsWeb && kReleaseMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  } catch (e, stack) {
    debugPrint('Firebase init failed: $e\n$stack');
  }

  try {
    await NotificationService().init();
  } catch (e, stack) {
    debugPrint('Notification init failed: $e\n$stack');
  }

  runApp(const EsimKrdApp());
}

class EsimKrdApp extends StatefulWidget {
  const EsimKrdApp({super.key});

  @override
  State<EsimKrdApp> createState() => _EsimKrdAppState();
}

class _EsimKrdAppState extends State<EsimKrdApp> {
  final _api = ApiClient();
  final _localeService = LocaleService();
  final _connectivity = ConnectivityService();
  final _deepLinks = DeepLinkService();
  late final PushNotificationService _push = PushNotificationService(_api);
  bool _ready = false;
  _AppPhase _phase = _AppPhase.home;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await Future.wait([
        initializeDateFormatting('en'),
        initializeDateFormatting('ar'),
        _api.loadToken(),
        _localeService.load(),
        CurrencyPreferenceService.instance.load(),
        _connectivity.init(),
        _deepLinks.init(),
        _push.init(),
      ]);
      _push.onNotificationOpened = _deepLinks.handlePushData;
    } catch (e, stack) {
      debugPrint('App init partial failure: $e\n$stack');
    }

    final completed = await OnboardingService.isCompleted();
    if (mounted) {
      setState(() {
        _ready = true;
        _phase = completed ? _AppPhase.home : _AppPhase.onboarding;
      });
    }

    // Slow network / push work — do not block first screen.
    unawaited(_deferredStartup());
  }

  Future<void> _deferredStartup() async {
    try {
      await AppConfig.load(_api);
      await _push.setupAfterLaunch();
      if (_api.isLoggedIn) {
        await _push.registerAfterLogin();
      }
    } catch (e, stack) {
      debugPrint('Deferred startup failure: $e\n$stack');
    }
  }

  Future<void> _onOnboardingFinished() async {
    await OnboardingService.markCompleted();
    if (mounted) setState(() => _phase = _AppPhase.home);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeService,
      builder: (context, _) {
        return MaterialApp(
          title: 'eSIM KRD',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: _localeService.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            KuMaterialLocalizationsDelegate(),
            KuCupertinoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: _localeService.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: KeyboardDismisser(child: child!),
            );
          },
          home: !_ready
              ? const Scaffold(
                  backgroundColor: AppColors.background,
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: switch (_phase) {
                    _AppPhase.onboarding => OnboardingScreen(
                        key: const ValueKey('onboarding'),
                        onFinished: _onOnboardingFinished,
                      ),
                    _AppPhase.home => MainShellScreen(
                        key: const ValueKey('home'),
                        api: _api,
                        localeService: _localeService,
                        connectivity: _connectivity,
                        deepLinks: _deepLinks,
                        pushService: _push,
                      ),
                  },
                ),
        );
      },
    );
  }
}
