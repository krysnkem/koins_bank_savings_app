import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Animated shimmering skeleton loader for cards, text lines, and avatars.
class AppShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const AppShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  const AppShimmer.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle;

  const AppShimmer.card({
    super.key,
    this.width = double.infinity,
    this.height = 76,
    this.borderRadius = AppRadius.card,
  }) : shape = BoxShape.rectangle;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : (widget.borderRadius ?? AppRadius.input),
            gradient: LinearGradient(
              begin: Alignment(-2.0 + (4.0 * _controller.value), -0.3),
              end: Alignment(-0.5 + (4.0 * _controller.value), 0.3),
              colors: const [
                Color(0xFFE5E7EB),
                Color(0xFFF3F4F6),
                Color(0xFFE5E7EB),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer skeleton replicating the layout of a Post card
class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Row(
          children: [
            AppShimmer.circle(size: 40),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(height: 14, width: 140),
                  SizedBox(height: 8),
                  AppShimmer(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton replicating the layout of a Recent Savings card
class RecentSavingsCardShimmer extends StatelessWidget {
  const RecentSavingsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Row(
          children: [
            AppShimmer.circle(size: 40),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(height: 14, width: 120),
                  SizedBox(height: 8),
                  AppShimmer(height: 12, width: 80),
                ],
              ),
            ),
            AppShimmer(height: 16, width: 70),
          ],
        ),
      ),
    );
  }
}
