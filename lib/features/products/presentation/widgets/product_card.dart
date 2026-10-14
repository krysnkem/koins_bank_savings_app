import 'package:flutter/material.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';

class ProductCard extends StatelessWidget {
  final UiProduct product;
  final VoidCallback onView;

  const ProductCard({super.key, required this.product, required this.onView});

  IconData get _icon => switch (product.icon) {
        IconName.flag => Icons.flag_outlined,
        IconName.lock => Icons.lock_outline,
        IconName.school => Icons.school_outlined,
        IconName.flight => Icons.flight_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(_icon, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(product.duration, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(
                  '${Formatters.percentage(product.interestRate)} p.a.',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(product.shortDescription, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // EXPECTATION: navigate to Savings Details for this product id.
                  onView();
                },
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
