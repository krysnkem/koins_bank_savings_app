import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/products/data/datasources/products_remote_data_source.dart';
import 'package:koins_savings_app/features/products/data/models/savings_product.dart';
import 'package:koins_savings_app/features/products/data/repositories/products_repository.dart';

class FakeProductsRemoteDataSource implements ProductsRemoteDataSource {
  FakeProductsRemoteDataSource({this.networkError = false});

  bool networkError;

  static final _products = [
    const SavingsProduct(
      id: '1',
      name: 'Target Savings',
      interestRate: 12,
      duration: '12 Months',
      shortDescription: 'Save towards a specific goal.',
      minimumDeposit: 5000,
    ),
    const SavingsProduct(
      id: '2',
      name: 'Fixed Deposit',
      interestRate: 18,
      duration: '6 Months',
      shortDescription: 'Lock funds for higher interest.',
      minimumDeposit: 5000,
    ),
  ];

  @override
  Future<List<SavingsProduct>> getSavingsProducts() async {
    if (networkError) throw const NetworkException();
    return List.from(_products);
  }

  @override
  Future<SavingsProduct> getProductById(String id) async {
    if (networkError) throw const NetworkException();
    return _products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw const ServerException('Product not found'),
    );
  }
}

void main() {
  late FakeProductsRemoteDataSource remote;
  late ProductsRepository repository;

  setUp(() {
    remote = FakeProductsRemoteDataSource();
    repository = ProductsRepositoryImpl(remoteDataSource: remote);
  });

  group('ProductsRepository.getProducts', () {
    test('returns list of products from remote', () async {
      final products = await repository.getProducts();

      expect(products.length, 2);
      expect(products.first.name, 'Target Savings');
    });

    test('propagates NetworkException', () async {
      remote.networkError = true;

      expect(
        () => repository.getProducts(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('ProductsRepository.getProductById', () {
    test('returns product for valid id', () async {
      final product = await repository.getProductById('1');

      expect(product.id, '1');
      expect(product.interestRate, 12);
    });

    test('throws ServerException for unknown id', () async {
      expect(
        () => repository.getProductById('999'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
