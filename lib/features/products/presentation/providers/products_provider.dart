import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/mock_backend_service.dart';
import '../../data/datasources/products_remote_data_source.dart';
import '../../data/models/savings_product.dart';
import '../../data/repositories/products_repository.dart';

sealed class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<SavingsProduct> products;
  const ProductsLoaded(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(
    remoteDataSource: ProductsRemoteDataSourceImpl(MockBackendService()),
  );
});

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(repo);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this._repository) : super(const ProductsInitial());

  final ProductsRepository _repository;

  Future<void> load() async {
    state = const ProductsLoading();
    try {
      final products = await _repository.getProducts();
      state = ProductsLoaded(products);
    } catch (e) {
      state = ProductsError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<SavingsProduct> loadById(String id) {
    return _repository.getProductById(id);
  }
}
