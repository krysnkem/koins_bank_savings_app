import '../../../../services/backend_service.dart';
import '../models/savings_product.dart';

abstract class ProductsRemoteDataSource {
  Future<List<SavingsProduct>> getSavingsProducts();

  Future<SavingsProduct> getProductById(String id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._backend);

  final BackendService _backend;

  @override
  Future<List<SavingsProduct>> getSavingsProducts() {
    // TODO: return _backend.getSavingsProducts()
    throw UnimplementedError('TODO $_backend');
  }

  @override
  Future<SavingsProduct> getProductById(String id) {
    // TODO: return _backend.getProductById(id)
    throw UnimplementedError('TODO $_backend');
  }
}
