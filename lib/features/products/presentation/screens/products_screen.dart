import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/error_state.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

/// Screen displaying the catalog of savings products with delayed loading when visible.
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Delay loading data until the screen is mounted and visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(productsNotifierProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Products'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(productsNotifierProvider.notifier).load(),
        child: switch (state) {
          ProductsInitial() || ProductsLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ProductsError(:final message) => ErrorState(
              message: message,
              onRetry: () => ref.read(productsNotifierProvider.notifier).load(),
            ),
          ProductsLoaded() => ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: kProducts.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
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
        },
      ),
    );
  }
}
