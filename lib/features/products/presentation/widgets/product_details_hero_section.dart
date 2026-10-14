import 'package:flutter/material.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';

/// Hero presentation section on Product Details screen.
class ProductDetailsHeroSection extends StatelessWidget {
  final UiProduct product;

  const ProductDetailsHeroSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
              boxShadow: AppShadows.avatarGlow,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.track_changes,
              color: AppColors.primary,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          product.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${Formatters.percentage(product.interestRate)} p.a.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
