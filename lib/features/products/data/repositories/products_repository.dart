import '../datasources/products_remote_data_source.dart';
import '../models/savings_product.dart';

abstract class ProductsRepository {
  Future<List<SavingsProduct>> getProducts();

  Future<SavingsProduct> getProductById(String id);
}

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({required ProductsRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final ProductsRemoteDataSource _remote;

  @override
  Future<List<SavingsProduct>> getProducts() {
    return _remote.getSavingsProducts();
  }

  @override
  Future<SavingsProduct> getProductById(String id) {
    return _remote.getProductById(id);
  }
}
