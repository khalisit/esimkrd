import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../utils/order_history.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/app_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/account_login_form.dart';
import '../widgets/currency_selector.dart';
import '../widgets/primary_button.dart';
import '../widgets/referral_section.dart';

const _whatsappSupportUrl = 'https://wa.me/message/HBXOVB6EBQQBB1';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.api,
    required this.localeService,
    required this.onAuthChanged,
  });

  final ApiClient api;
  final LocaleService localeService;
  final VoidCallback onAuthChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _auth = AuthService(widget.api);
  bool _loading = false;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (!widget.api.isLoggedIn) return;
    try {
      final response = await widget.api.get('/auth/me', auth: true);
      if (mounted) {
        setState(() => _user = response['user'] as Map<String, dynamic>?);
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401 && mounted) {
        setState(() => _user = null);
        widget.onAuthChanged();
      }
    } catch (_) {}
  }

  Future<void> _logout() async {
    setState(() => _loading = true);
    try {
      await _auth.signOut();
      setState(() => _user = null);
      widget.onAuthChanged();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteAccountConfirm,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _loading = true);
    try {
      await _auth.deleteAccount();
      setState(() => _user = null);
      widget.onAuthChanged();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onSocialSuccess() async {
    await _loadUser();
    widget.onAuthChanged();
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
    final l10n = AppLocalizations.of(context)!;
    final isGuest = !widget.api.isLoggedIn;
    final bottom = NavIslandLayout.bottomClearance(context);

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => await _loadUser(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              sliver: SliverToBoxAdapter(
                child: FadeSlideIn(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.profileTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const ProfileCurrencySection(compact: true),
                    ],
                  ),
                ),
              ),
            ),
            if (isGuest)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, bottom + 24),
                  child: AccountLoginForm(
                    auth: _auth,
                    onSuccess: _onSocialSuccess,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, bottom),
                sliver: SliverList.list(
                  children: [
                    if (_user != null)
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 60),
                        child: _LoggedInCard(
                          name: _user!['name'] as String? ?? l10n.profileGuest,
                          email: _user!['email'] as String? ?? '',
                          onLogout: _logout,
                          onDeleteAccount: _deleteAccount,
                          logoutLabel: l10n.logout,
                          deleteAccountLabel: l10n.deleteAccount,
                          loading: _loading,
                        ),
                      ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 100),
                      child: _AccountMenuCard(
                        api: widget.api,
                        l10n: l10n,
                        localeService: widget.localeService,
                        onWhatsAppSupport: _openWhatsAppSupport,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 140),
                      child: AccountLegalFooter(l10n: l10n),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AccountMenuCard extends StatelessWidget {
  const _AccountMenuCard({
    required this.api,
    required this.l10n,
    required this.localeService,
    required this.onWhatsAppSupport,
  });

  final ApiClient api;
  final AppLocalizations l10n;
  final LocaleService localeService;
  final VoidCallback onWhatsAppSupport;

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'کوردی',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: localeService.locale.languageCode == 'ku'
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    localeService.setLocale(const Locale('ku'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'English',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: localeService.locale.languageCode == 'en'
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    localeService.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text(
                    'العربية',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: localeService.locale.languageCode == 'ar'
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    localeService.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.language_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            title: Text(l10n.language),
            subtitle: Text(
              localeService.locale.languageCode == 'ku'
                  ? 'کوردی'
                  : localeService.locale.languageCode == 'ar'
                  ? 'العربية'
                  : 'English',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 22,
            ),
            onTap: () => _showLanguagePicker(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Divider(
            height: 1,
            indent: 52,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            title: Text(l10n.orderHistoryTitle),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 22,
            ),
            onTap: () => OrderHistory.open(context, api),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Divider(
            height: 1,
            indent: 52,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/images/whatsap.png',
                fit: BoxFit.contain,
              ),
            ),
            title: Text(l10n.helpSupport),
            subtitle: Text(
              'WhatsApp',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF25D366),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.arrow_outward_rounded,
              size: 18,
              color: AppColors.textMuted.withValues(alpha: 0.85),
            ),
            onTap: onWhatsAppSupport,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Divider(
            height: 1,
            indent: 52,
            color: AppColors.border.withValues(alpha: 0.6),
          ),
          ReferralSection(api: api, compact: true),
        ],
      ),
    );
  }
}

class _LoggedInCard extends StatelessWidget {
  const _LoggedInCard({
    required this.name,
    required this.email,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.logoutLabel,
    required this.deleteAccountLabel,
    required this.loading,
  });

  final String name;
  final String email;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final String logoutLabel;
  final String deleteAccountLabel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientPrimary,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: logoutLabel,
            icon: Icons.logout_rounded,
            loading: loading,
            height: 48,
            onPressed: loading ? null : onLogout,
          ),
          TextButton.icon(
            onPressed: loading ? null : onDeleteAccount,
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text(deleteAccountLabel),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}
