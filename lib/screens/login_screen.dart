import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/account_login_form.dart';
import '../widgets/app_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/glow_background.dart';
import '../widgets/primary_button.dart';

const _whatsappSupportUrl = 'https://wa.me/message/HBXOVB6EBQQBB1';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.api});

  final ApiClient api;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _auth = AuthService(widget.api);
  bool _loading = false;

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      await _auth.signOut();
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openWhatsAppSupport() async {
    final uri = Uri.parse(_whatsappSupportUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorGeneric('WhatsApp')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: widget.api.isLoggedIn
                      ? _LoggedInView(onLogout: _logout, loading: _loading)
                      : AccountLoginForm(
                          auth: _auth,
                          onSuccess: () {
                            if (mounted) Navigator.of(context).pop(true);
                          },
                          showWhatsAppSupport: true,
                          onWhatsAppSupport: _openWhatsAppSupport,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoggedInView extends StatelessWidget {
  const _LoggedInView({required this.onLogout, required this.loading});

  final VoidCallback onLogout;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeSlideIn(
      child: AppCard(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientPrimary,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.loginSuccess,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.canBuyNow,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: l10n.logout,
              icon: Icons.logout_rounded,
              loading: loading,
              onPressed: loading ? null : onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
