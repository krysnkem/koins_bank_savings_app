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
    return _backend.getSavingsProducts();
  }

  @override
  Future<SavingsProduct> getProductById(String id) {
    return _backend.getProductById(id);
  }
}
