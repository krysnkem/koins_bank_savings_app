import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
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
        state = ProductsError(e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''));
      }
    }
  }

  Future<SavingsProduct> loadById(String id) {
    return _repository.getProductById(id);
  }
}
