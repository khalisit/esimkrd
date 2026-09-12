import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class SocialAuthButtons extends StatefulWidget {
  const SocialAuthButtons({
    super.key,
    required this.auth,
    required this.onSuccess,
  });

  final AuthService auth;
  final VoidCallback onSuccess;

  @override
  State<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends State<SocialAuthButtons> {
  _SocialProvider? _loading;

  Future<void> _run(_SocialProvider provider, Future<bool> Function() action) async {
    if (_loading != null) return;
    setState(() => _loading = provider);
    try {
      final ok = await action();
      if (ok) widget.onSuccess();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final message = e is AuthServiceException ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(message))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AuthOptionTile(
          imageAsset: 'assets/images/google.png',
          title: l10n.continueWithGoogle,
          subtitle: l10n.googleSignInDesc,
          loading: _loading == _SocialProvider.google,
          disabled: _loading != null,
          onTap: () => _run(
            _SocialProvider.google,
            widget.auth.signInWithGoogle,
          ),
        ),
        if (appleSignInAvailable) ...[
          const SizedBox(height: 10),
          _AuthOptionTile(
            icon: const Icon(Icons.apple, size: 26, color: Colors.white),
            iconBackground: Colors.black,
            title: l10n.continueWithApple,
            subtitle: l10n.googleSignInDesc,
            loading: _loading == _SocialProvider.apple,
            disabled: _loading != null,
            onTap: () => _run(
              _SocialProvider.apple,
              widget.auth.signInWithApple,
            ),
          ),
        ],
      ],
    );
  }
}

enum _SocialProvider { google, apple }

class _AuthOptionTile extends StatefulWidget {
  const _AuthOptionTile({
    this.imageAsset,
    this.icon,
    this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.loading,
    required this.disabled,
    required this.onTap,
  });

  final String? imageAsset;
  final Widget? icon;
  final Color? iconBackground;
  final String title;
  final String subtitle;
  final bool loading;
  final bool disabled;
  final VoidCallback onTap;

  @override
  State<_AuthOptionTile> createState() => _AuthOptionTileState();
}

class _AuthOptionTileState extends State<_AuthOptionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final canTap = !widget.disabled && !widget.loading;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: canTap ? (_) => setState(() => _pressed = true) : null,
      onTapUp: canTap
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: canTap ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: widget.disabled
                ? AppColors.surfaceMuted.withValues(alpha: 0.6)
                : _pressed
                ? AppColors.surfaceMuted
                : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.border.withValues(alpha: 0.85),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: _pressed || widget.disabled
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
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: widget.iconBackground ??
                      (_pressed
                          ? AppColors.surface
                          : AppColors.surfaceMuted.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: widget.loading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: widget.iconBackground != null
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      )
                    : widget.imageAsset != null
                    ? Image.asset(widget.imageAsset!, fit: BoxFit.contain)
                    : widget.icon,
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
              AnimatedSlide(
                offset: _pressed ? const Offset(0.08, 0) : Offset.zero,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textMuted.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
