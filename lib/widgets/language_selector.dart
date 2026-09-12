import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../theme/app_colors.dart';
import 'language_flag.dart';

const _menuWidth = 200.0;
const _compactButtonSize = 42.0;

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.localeService,
    this.compact = false,
    this.expanded = false,
  });

  final LocaleService localeService;
  final bool compact;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeService,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context)!;
        final currentLang = localeService.locale.languageCode;

        if (expanded) {
          return _LanguageMenu(
            localeService: localeService,
            offset: const Offset(0, 8),
            menuWidth: double.infinity,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  LanguageFlag(languageCode: currentLang, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          _labelFor(l10n, currentLang),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: AppColors.textMuted.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
          );
        }

        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final horizontalOffset = isRtl
            ? 0.0
            : _compactButtonSize - _menuWidth;

        return _LanguageMenu(
          localeService: localeService,
          offset: Offset(horizontalOffset, 6),
          menuWidth: _menuWidth,
          child: Material(
            color: AppColors.surface,
            shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: _compactButtonSize,
              height: _compactButtonSize,
              child: Center(
                child: LanguageFlag(languageCode: currentLang, size: compact ? 30 : 28),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _labelFor(AppLocalizations l10n, String code) {
    return switch (code) {
      'ku' => l10n.kurdish,
      'ar' => l10n.arabic,
      'en' => l10n.english,
      _ => l10n.english,
    };
  }
}

class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu({
    required this.localeService,
    required this.child,
    required this.offset,
    required this.menuWidth,
  });

  final LocaleService localeService;
  final Widget child;
  final Offset offset;
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale>(
      tooltip: l10n.language,
      offset: offset,
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(
        minWidth: menuWidth,
        maxWidth: menuWidth == double.infinity ? double.infinity : menuWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.surface,
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      onSelected: localeService.setLocale,
      itemBuilder: (context) => [
        _item(context, const Locale('ku'), l10n.kurdish),
        _item(context, const Locale('ar'), l10n.arabic),
        _item(context, const Locale('en'), l10n.english),
      ],
      child: child,
    );
  }

  PopupMenuItem<Locale> _item(
    BuildContext context,
    Locale locale,
    String label,
  ) {
    final selected = localeService.locale.languageCode == locale.languageCode;

    return PopupMenuItem(
      value: locale,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          LanguageFlag(languageCode: locale.languageCode, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}

/// Profile screen language picker — three visual chips instead of a dropdown.
class ProfileLanguageSection extends StatelessWidget {
  const ProfileLanguageSection({super.key, required this.localeService});

  final LocaleService localeService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: localeService,
      builder: (context, _) {
        final current = localeService.locale.languageCode;
        final options = [
          _LangOption(const Locale('ku'), l10n.kurdish),
          _LangOption(const Locale('ar'), l10n.arabic),
          _LangOption(const Locale('en'), l10n.english),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.translate_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        LanguageSelector._labelFor(l10n, current),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                    child: _LanguageChip(
                      locale: options[i].locale,
                      label: options[i].label,
                      selected: current == options[i].locale.languageCode,
                      onTap: () => localeService.setLocale(options[i].locale),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LangOption {
  const _LangOption(this.locale, this.label);

  final Locale locale;
  final String label;
}

class _LanguageChip extends StatefulWidget {
  const _LanguageChip({
    required this.locale,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Locale locale;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_LanguageChip> createState() => _LanguageChipState();
}

class _LanguageChipState extends State<_LanguageChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.surfaceMuted.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.selected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.border.withValues(alpha: 0.8),
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LanguageFlag(
                languageCode: widget.locale.languageCode,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: widget.selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              if (widget.selected) ...[
                const SizedBox(height: 6),
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
