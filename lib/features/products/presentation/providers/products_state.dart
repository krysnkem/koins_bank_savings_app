import '../../data/models/savings_product.dart';

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
