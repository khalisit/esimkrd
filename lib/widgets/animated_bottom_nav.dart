import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'glass_panel.dart';

/// Layout constants for the floating nav island.
abstract final class NavIslandLayout {
  static const islandHeight = 72.0;
  static const sideGap = 20.0;
  static const bottomGap = 20.0;

  static double bottomClearance(BuildContext context) {
    return islandHeight + bottomGap + MediaQuery.viewPaddingOf(context).bottom + 12;
  }
}

class AnimatedBottomNav extends StatelessWidget {
  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _NavItem(
        Icons.storefront_rounded,
        Icons.storefront_outlined,
        l10n.navStore,
      ),
      _NavItem(
        Icons.sim_card_rounded,
        Icons.sim_card_outlined,
        l10n.navMyEsims,
      ),
      _NavItem(
        Icons.person_rounded,
        Icons.person_outline_rounded,
        l10n.navProfile,
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      //ڕەنگی باکگرانودی  ناڤیگەیشن
      child: GlassPanel(
        borderRadius: 29,
        blurSigma: 4,
        fillOpacity: 0.72,
        fillColor: const Color.fromARGB(255, 228, 223, 223),
        borderWidth: 0,
        child: SizedBox(
          height: NavIslandLayout.islandHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / items.length;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositionedDirectional(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    start: itemWidth * currentIndex + 8,
                    top: 8,
                    width: itemWidth - 16,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (index) {
                      final selected = index == currentIndex;
                      final item = items[index];

                      return Expanded(
                        child: _NavTap(
                          selected: selected,
                          icon: selected ? item.activeIcon : item.icon,
                          label: item.label,
                          onTap: () => onTap(index),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.activeIcon, this.icon, this.label);

  final IconData activeIcon;
  final IconData icon;
  final String label;
}

class _NavTap extends StatefulWidget {
  const _NavTap({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavTap> createState() => _NavTapTapState();
}

class _NavTapTapState extends State<_NavTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.94,
      upperBound: 1,
      value: 1,
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) => _press.forward(),
      onTapCancel: () => _press.forward(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                widget.icon,
                key: ValueKey('${widget.selected}_${widget.icon.codePoint}'),
                size: 24,
                color: widget.selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.selected ? Colors.white : AppColors.textPrimary,
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
