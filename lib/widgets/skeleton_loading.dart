import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shimmer pulse for skeleton placeholders.
class ShimmerScope extends StatefulWidget {
  const ShimmerScope({super.key, required this.child});

  final Widget child;

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}

class _ShimmerScopeState extends State<ShimmerScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShimmerScopeData(
          value: _controller.value,
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerScopeData extends InheritedWidget {
  const ShimmerScopeData({
    super.key,
    required this.value,
    required super.child,
  });

  final double value;

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ShimmerScopeData>()
            ?.value ??
        0;
  }

  @override
  bool updateShouldNotify(ShimmerScopeData oldWidget) =>
      oldWidget.value != value;
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final shimmer = ShimmerScopeData.of(context);
    final base = AppColors.surfaceMuted;
    final highlight = AppColors.border.withValues(alpha: 0.9);
    final t = (shimmer * 2).clamp(0.0, 1.0);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(-1 + t, 0),
          end: Alignment(1 + t, 0),
          colors: [base, highlight, base],
        ),
      ),
    );
  }
}

class CountryListSkeleton extends StatelessWidget {
  const CountryListSkeleton({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, index) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const SkeletonBox(width: 48, height: 48, borderRadius: 14),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 140 + (index % 3) * 20, height: 14),
                    const SizedBox(height: 8),
                    const SkeletonBox(width: 48, height: 12, borderRadius: 6),
                  ],
                ),
              ),
              const SkeletonBox(width: 32, height: 32, borderRadius: 999),
            ],
          ),
        ),
      ),
    );
  }
}

class PackageListSkeleton extends StatelessWidget {
  const PackageListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(width: 180, height: 16),
              const SizedBox(height: 10),
              const SkeletonBox(width: 120, height: 12),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: SkeletonBox(width: double.infinity, height: 40, borderRadius: 999)),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 88, height: 40, borderRadius: 999),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EsimListSkeleton extends StatelessWidget {
  const EsimListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 44, height: 44, borderRadius: 12),
                  const SizedBox(width: 12),
                  const Expanded(child: SkeletonBox(width: double.infinity, height: 14)),
                  const SkeletonBox(width: 64, height: 22, borderRadius: 999),
                ],
              ),
              const SizedBox(height: 14),
              const SkeletonBox(width: double.infinity, height: 8, borderRadius: 999),
              const SizedBox(height: 8),
              const SkeletonBox(width: 160, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 44, height: 44, borderRadius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        const SkeletonBox(width: double.infinity, height: 14),
                        const SizedBox(height: 8),
                        const SkeletonBox(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const SkeletonBox(width: double.infinity, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
