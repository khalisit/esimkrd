import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../screens/legal_document_screen.dart';
import '../screens/register_screen.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/page_transitions.dart';
import 'checkout_order_summary.dart';
import 'fade_slide_in.dart';
import 'primary_button.dart';
import 'social_auth_buttons.dart';

/// Guest account login — matches checkout / payment sheet visual language.
class AccountLoginForm extends StatelessWidget {
  const AccountLoginForm({
    super.key,
    required this.auth,
    required this.onSuccess,
    this.onWhatsAppSupport,
    this.showWhatsAppSupport = false,
    this.showLegalFooter = true,
  });

  final AuthService auth;
  final VoidCallback onSuccess;
  final VoidCallback? onWhatsAppSupport;
  final bool showWhatsAppSupport;
  final bool showLegalFooter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeSlideIn(
          offsetY: 14,
          child: _LoginSheetCard(l10n: l10n, auth: auth, onSuccess: onSuccess),
        ),
        if (showWhatsAppSupport && onWhatsAppSupport != null) ...[
          const SizedBox(height: 12),
          FadeSlideIn(
            delay: const Duration(milliseconds: 120),
            offsetY: 10,
            child: _SupportWhatsAppTile(
              label: l10n.helpSupport,
              onTap: onWhatsAppSupport!,
            ),
          ),
        ],
        if (showLegalFooter) ...[
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 180),
            offsetY: 8,
            child: AccountLegalFooter(l10n: l10n),
          ),
        ],
      ],
    );
  }
}

class _LoginSheetCard extends StatefulWidget {
  const _LoginSheetCard({
    required this.l10n,
    required this.auth,
    required this.onSuccess,
  });

  final AppLocalizations l10n;
  final AuthService auth;
  final VoidCallback onSuccess;

  @override
  State<_LoginSheetCard> createState() => _LoginSheetCardState();
}

class _LoginSheetCardState extends State<_LoginSheetCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showEmailForm = false;
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final ok = await widget.auth.loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (ok) widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      final message = e is AuthServiceException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.errorGeneric(message))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openRegister() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(AppPageRoute(page: RegisterScreen(auth: widget.auth)));
    if (result == true && mounted) widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: 48,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.gradientPrimary,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.login,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.profileGuestHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AccountSignInTile(
                    title: l10n.signInWithAccount,
                    subtitle: l10n.emailPasswordDesc,
                    expanded: _showEmailForm,
                    onTap: () =>
                        setState(() => _showEmailForm = !_showEmailForm),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: _showEmailForm
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    enabled: !_loading,
                                    decoration: InputDecoration(
                                      labelText: l10n.email,
                                      prefixIcon: const Icon(
                                        Icons.mail_outline_rounded,
                                      ),
                                    ),
                                    validator: (v) {
                                      final value = v?.trim() ?? '';
                                      if (value.isEmpty) {
                                        return l10n.fieldRequired;
                                      }
                                      if (!value.contains('@')) {
                                        return l10n.invalidEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    enabled: !_loading,
                                    onFieldSubmitted: (_) => _login(),
                                    decoration: InputDecoration(
                                      labelText: l10n.password,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_rounded,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return l10n.fieldRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  PrimaryButton(
                                    label: l10n.login,
                                    icon: Icons.login_rounded,
                                    loading: _loading,
                                    onPressed: _loading ? null : _login,
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: _loading ? null : _openRegister,
                                    child: Text(l10n.noAccount),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 18),
                  SocialAuthButtons(
                    auth: widget.auth,
                    onSuccess: widget.onSuccess,
                  ),
                  const SizedBox(height: 20),
                  SecurePaymentFooter(label: l10n.signInDisclaimer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountSignInTile extends StatefulWidget {
  const _AccountSignInTile({
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onTap;

  @override
  State<_AccountSignInTile> createState() => _AccountSignInTileState();
}

class _AccountSignInTileState extends State<_AccountSignInTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: widget.expanded || _pressed
                ? AppColors.surfaceMuted
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.expanded
                  ? AppColors.primary.withValues(alpha: 0.45)
                  : _pressed
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.border.withValues(alpha: 0.85),
              width: widget.expanded || _pressed ? 1.5 : 1,
            ),
            boxShadow: widget.expanded || _pressed
                ? null
                : [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.mail_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: widget.expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountLegalFooter extends StatelessWidget {
  const AccountLegalFooter({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LegalLink(
            label: l10n.termsOfService,
            onTap: () {
              Navigator.of(context).push(
                AppPageRoute(
                  page: const LegalDocumentScreen(
                    type: LegalDocumentType.terms,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _LegalLink(
            label: l10n.privacyPolicy,
            onTap: () => _openPrivacyPolicy(context),
          ),
        ),
      ],
    );
  }
}

Future<void> _openPrivacyPolicy(BuildContext context) async {
  final uri = Uri.parse(AppConfig.privacyPolicyUrl);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.errorGeneric('Privacy')),
      ),
    );
  }
}

class _SupportWhatsAppTile extends StatefulWidget {
  const _SupportWhatsAppTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_SupportWhatsAppTile> createState() => _SupportWhatsAppTileState();
}

class _SupportWhatsAppTileState extends State<_SupportWhatsAppTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _pressed ? AppColors.surfaceMuted : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFF25D366).withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.85),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: _pressed
                ? null
                : [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  'assets/images/whatsap.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'WhatsApp',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF25D366),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                size: 18,
                color: AppColors.textMuted.withValues(alpha: 0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
