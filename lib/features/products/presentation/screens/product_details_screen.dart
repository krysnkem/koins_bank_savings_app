import 'package:flutter/material.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../widgets/common/error_state.dart';
import '../../../../widgets/common/primary_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.md),
            const CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.track_changes, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              '${Formatters.percentage(product.interestRate)} p.a.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
                    title: const Text('Minimum Deposit'),
                    subtitle: Text(Formatters.naira(product.minimumDeposit)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                    title: const Text('Duration'),
                    subtitle: Text(product.duration),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(product.shortDescription, style: const TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            PrimaryButton(
              label: 'Create Savings',
              onPressed: () {
                // EXPECTATION: open Create Savings with this product pre-selected.
                Navigator.of(context).pushNamed('/create', arguments: product.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
