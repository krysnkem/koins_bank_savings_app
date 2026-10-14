import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Products'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: kProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final product = kProducts[index];
          return ProductCard(
            product: product,
            onView: () {
              context.push('/product/${product.id}');
            },
          );
        },
      ),
    );
  }
}
