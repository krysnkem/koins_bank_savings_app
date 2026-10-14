import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/error_state.dart';
import '../../../../widgets/common/primary_button.dart';
import '../widgets/product_details_hero_section.dart';
import '../widgets/product_details_specs_card.dart';

/// Screen displaying the details and specifications for a savings product.
class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = productById(productId);
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Plan Details')),
        body: const ErrorState(message: 'Product not found'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductDetailsHeroSection(product: product),
              const SizedBox(height: AppSpacing.xl),
              ProductDetailsSpecsCard(product: product),
              const SizedBox(height: AppSpacing.lg),
              Text(
                product.shortDescription,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Create Savings',
                onPressed: () => context.push('/create/${product.id}'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
