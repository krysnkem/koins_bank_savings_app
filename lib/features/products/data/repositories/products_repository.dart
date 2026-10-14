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
    // TODO: return _remote.getSavingsProducts() and rethrow NetworkException
    throw UnimplementedError('TODO $_remote');
  }

  @override
  Future<SavingsProduct> getProductById(String id) {
    // TODO: return _remote.getProductById(id)
    throw UnimplementedError('TODO $_remote');
  }
}
