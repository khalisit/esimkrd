import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/currency_preference_service.dart';
import '../theme/app_colors.dart';

class ProfileCurrencySection extends StatelessWidget {
  const ProfileCurrencySection({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) return const _CompactCurrencyPicker();

    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: CurrencyPreferenceService.instance,
      builder: (context, _) {
        final current = CurrencyPreferenceService.instance.mode;
        final options = [
          _CurrencyOption(CurrencyDisplayMode.both, l10n.currencyBoth),
          _CurrencyOption(CurrencyDisplayMode.usd, l10n.currencyUsd),
          _CurrencyOption(CurrencyDisplayMode.iqd, l10n.currencyIqd),
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
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.currencyDisplay,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _labelFor(l10n, current),
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
                    child: _CurrencyChip(
                      label: options[i].label,
                      selected: current == options[i].mode,
                      onTap: () =>
                          CurrencyPreferenceService.instance.setMode(options[i].mode),
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

  static String _labelFor(AppLocalizations l10n, CurrencyDisplayMode mode) {
    return switch (mode) {
      CurrencyDisplayMode.both => l10n.currencyBoth,
      CurrencyDisplayMode.usd => l10n.currencyUsd,
      CurrencyDisplayMode.iqd => l10n.currencyIqd,
    };
  }
}

/// Small segmented currency picker for the account header row.
class _CompactCurrencyPicker extends StatelessWidget {
  const _CompactCurrencyPicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: CurrencyPreferenceService.instance,
      builder: (context, _) {
        final current = CurrencyPreferenceService.instance.mode;
        final options = [
          _CurrencyOption(CurrencyDisplayMode.usd, 'USD'),
          _CurrencyOption(CurrencyDisplayMode.iqd, 'IQD'),
          _CurrencyOption(CurrencyDisplayMode.both, l10n.currencyBoth),
        ];

        return Container(
          height: 34,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < options.length; i++) ...[
                _CompactCurrencySegment(
                  label: options[i].label,
                  selected: current == options[i].mode,
                  onTap: () =>
                      CurrencyPreferenceService.instance.setMode(options[i].mode),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CompactCurrencySegment extends StatelessWidget {
  const _CompactCurrencySegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: selected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _CurrencyOption {
  const _CurrencyOption(this.mode, this.label);

  final CurrencyDisplayMode mode;
  final String label;
}

class _CurrencyChip extends StatefulWidget {
  const _CurrencyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CurrencyChip> createState() => _CurrencyChipState();
}

class _CurrencyChipState extends State<_CurrencyChip> {
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
          ),
          child: Column(
            children: [
              Text(
                widget.label,
                maxLines: 2,
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
