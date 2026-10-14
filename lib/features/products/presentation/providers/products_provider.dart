import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this._repository) : super(const ProductsInitial());

  final ProductsRepository _repository;

  Future<void> load() async {
    // TODO: emit Loading, _repository.getProducts, Loaded or ProductsError
    throw UnimplementedError('TODO $_repository');
  }

  Future<SavingsProduct> loadById(String id) {
    // TODO: return _repository.getProductById(id)
    throw UnimplementedError('TODO $_repository');
  }
}
