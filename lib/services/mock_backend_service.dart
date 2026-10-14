import 'package:http/http.dart' as http;

import '../core/network/network_checker.dart';
import '../features/auth/data/models/auth_user.dart';
import '../features/dashboard/data/models/financial_tip.dart';
import '../features/products/data/models/savings_product.dart';
import '../features/savings/data/models/savings_plan.dart';
import 'backend_service.dart';

class MockBackendService implements BackendService {
  MockBackendService({
    NetworkChecker? networkChecker,
    http.Client? httpClient,
  })  : _networkChecker = networkChecker ?? const NetworkCheckerImpl(),
        _httpClient = httpClient ?? http.Client();

  final NetworkChecker _networkChecker;
  final http.Client _httpClient;

  bool forceOffline = false;

  // ignore: unused_element
  Future<void> _ensureOnline() {
    // TODO: if forceOffline or !_networkChecker.isAvailable throw NetworkException
    throw UnimplementedError('TODO $_networkChecker $_httpClient $forceOffline');
  }

  // ignore: unused_element
  Future<void> _simulateLatency() {
    // TODO: await Future.delayed(Duration(milliseconds: ms))
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    // TODO: _ensureOnline, _simulateLatency
    // TODO: match AppConstants.mockEmail / mockPassword else AuthException
    throw UnimplementedError();
  }

  @override
  Future<List<SavingsProduct>> getSavingsProducts() async {
    // TODO: _ensureOnline, _simulateLatency, return the 4 hardcoded products
    throw UnimplementedError();
  }

  @override
  Future<SavingsProduct> getProductById(String id) async {
    // TODO: _ensureOnline, _simulateLatency
    // TODO: throw ServerException('Product not found') when id is missing
    throw UnimplementedError();
  }

  @override
  Future<List<SavingsPlan>> getSavingsPlans() async {
    // TODO: _ensureOnline, _simulateLatency, return in-memory plans (seed 3)
    throw UnimplementedError();
  }

  @override
  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    // TODO: _ensureOnline, _simulateLatency
    // TODO: ServerException if productId is unknown, else append and return
    throw UnimplementedError();
  }

  @override
  Future<List<FinancialTip>> getFinancialTips() async {
    // TODO: _ensureOnline, GET dummyjson /posts?limit=5 via _httpClient
    // TODO: map first 3 posts, else ServerException
    throw UnimplementedError();
  }
}
