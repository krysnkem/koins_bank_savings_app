import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/savings_product.dart';
import '../../data/repositories/products_repository.dart';
import 'products_state.dart';

export 'products_state.dart';

final productsNotifierProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(ProductsNotifier.new);

class ProductsNotifier extends Notifier<ProductsState> {
  late final ProductsRepository _repository;

  @override
  ProductsState build() {
    _repository = ref.watch(productsRepositoryProvider);
    return const ProductsInitial();
  }

  Future<void> load() async {
    state = const ProductsLoading();
    try {
      final products = await _repository.getProducts();
      state = ProductsLoaded(products);
    } catch (e) {
      if (e is AppException) {
        state = ProductsError(e.message);
      } else {
        state = ProductsError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }

  Future<SavingsProduct> loadById(String id) {
    return _repository.getProductById(id);
  }
}
