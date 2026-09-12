import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_client.dart';
import '../services/connectivity_service.dart';
import '../services/deep_link_service.dart';
import '../services/locale_service.dart';
import '../services/push_notification_service.dart';
import '../utils/page_transitions.dart';
import '../utils/payment_flow.dart';
import '../models/user_esim.dart';
import '../screens/esim_detail_screen.dart';
import '../screens/payment_result_screen.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/glow_background.dart';
import '../widgets/offline_banner.dart';
import 'my_esims_screen.dart';
import 'profile_screen.dart';
import 'store_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    required this.api,
    required this.localeService,
    required this.connectivity,
    required this.deepLinks,
    required this.pushService,
  });

  final ApiClient api;
  final LocaleService localeService;
  final ConnectivityService connectivity;
  final DeepLinkService deepLinks;
  final PushNotificationService pushService;

  @override
  State<MainShellScreen> createState() => MainShellScreenState();
}

class MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  final _myEsimsKey = GlobalKey<MyEsimsScreenState>();

  @override
  void initState() {
    super.initState();
    widget.deepLinks.addListener(_onDeepLink);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePendingDeepLink();
      if (widget.api.isLoggedIn) {
        widget.pushService.registerAfterLogin();
      }
    });
  }

  @override
  void dispose() {
    widget.deepLinks.removeListener(_onDeepLink);
    super.dispose();
  }

  void _onDeepLink() => _handlePendingDeepLink();

  Future<void> _handlePendingDeepLink() async {
    final action = widget.deepLinks.pendingAction;
    if (action == null || !mounted) return;

    widget.deepLinks.clearPendingAction();

    switch (action.type) {
      case DeepLinkActionType.order:
        if (action.id != null && widget.api.isLoggedIn) {
          await resumeCheckoutFlow(
            context: context,
            api: widget.api,
            orderId: action.id!,
          );
        }
        break;
      case DeepLinkActionType.esim:
        if (action.id != null && widget.api.isLoggedIn) {
          try {
            final response = await widget.api.get('/my-esims/${action.id}', auth: true);
            final esim = UserEsim.fromJson(response['data'] as Map<String, dynamic>);
            if (!mounted) return;
            await Navigator.of(context).push(
              AppPageRoute(page: EsimDetailScreen(api: widget.api, esim: esim)),
            );
          } catch (_) {}
        }
        break;
      case DeepLinkActionType.paymentSuccess:
        if (action.id != null && widget.api.isLoggedIn) {
          await Navigator.of(context).push(
            AppPageRoute(
              page: PaymentResultScreen(api: widget.api, orderId: action.id!),
            ),
          );
        }
        break;
      case DeepLinkActionType.paymentCancel:
      case DeepLinkActionType.referral:
      case DeepLinkActionType.promo:
        break;
    }
  }

  void _onTabChanged(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    if (index == 1) {
      _myEsimsKey.currentState?.refresh();
    }
  }

  void onAuthChanged() {
    setState(() {});
    if (widget.api.isLoggedIn) {
      widget.pushService.registerAfterLogin();
    } else {
      widget.pushService.unregister();
    }
    _myEsimsKey.currentState?.refresh();
  }

  void goToStore() => _onTabChanged(0);

  @override
  Widget build(BuildContext context) {
    // Use viewPadding so the island stays pinned when the keyboard opens on iOS.
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;

    return ListenableBuilder(
      listenable: widget.connectivity,
      builder: (context, _) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: GlowBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final offset = Tween<Offset>(
                      begin: const Offset(0, 0.02),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_currentIndex),
                    child: _buildPage(_currentIndex),
                  ),
                ),
              ),
              if (!widget.connectivity.isOnline)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: OfflineBanner(),
                ),
              Positioned(
                left: NavIslandLayout.sideGap,
                right: NavIslandLayout.sideGap,
                bottom: bottomSafe + NavIslandLayout.bottomGap,
                child: AnimatedBottomNav(
                  currentIndex: _currentIndex,
                  onTap: _onTabChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 1:
        return MyEsimsScreen(
          key: _myEsimsKey,
          api: widget.api,
          onGoStore: goToStore,
          onLogin: () => _onTabChanged(2),
          onSessionExpired: onAuthChanged,
        );
      case 2:
        return ProfileScreen(
          api: widget.api,
          localeService: widget.localeService,
          onAuthChanged: onAuthChanged,
        );
      case 0:
      default:
        return StoreScreen(
          api: widget.api,
          localeService: widget.localeService,
        );
    }
  }
}
