import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import '../core/constants/latency_constants.dart';
import '../core/errors/app_exception.dart';
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
    Duration? latency,
  })  : _networkChecker = networkChecker ?? const NetworkCheckerImpl(),
        _httpClient = httpClient ?? http.Client(),
        latency = latency ?? LatencyConstants.backend;

  final NetworkChecker _networkChecker;
  final http.Client _httpClient;

  Duration latency;
  bool forceOffline = false;

  static const List<SavingsProduct> _hardcodedProducts = [
    SavingsProduct(
      id: '1',
      name: 'Target Savings',
      interestRate: 12.0,
      duration: '12 Months',
      shortDescription: 'Save towards a specific goal with competitive returns.',
      minimumDeposit: 5000,
    ),
    SavingsProduct(
      id: '2',
      name: 'Fixed Deposit',
      interestRate: 18.0,
      duration: '6 Months',
      shortDescription: 'Lock funds for a fixed period and earn higher interest.',
      minimumDeposit: 5000,
    ),
    SavingsProduct(
      id: '3',
      name: 'Education Savings',
      interestRate: 10.0,
      duration: 'Flexible',
      shortDescription: 'Flexible savings plan designed for education goals.',
      minimumDeposit: 5000,
    ),
    SavingsProduct(
      id: '4',
      name: 'Vacation Savings',
      interestRate: 8.0,
      duration: 'Flexible',
      shortDescription: 'Build your travel fund at your own pace.',
      minimumDeposit: 5000,
    ),
  ];

  late final List<SavingsPlan> _plans = [
    SavingsPlan(
      id: 'seed-1',
      name: 'Emergency Fund',
      productId: '1',
      productName: 'Target Savings',
      amount: 120000,
      targetAmount: 500000,
      monthlyContribution: 20000,
      frequency: 'Monthly',
      duration: '12 Months',
      createdAt: DateTime.now(),
    ),
    SavingsPlan(
      id: 'seed-2',
      name: 'House Savings Plan',
      productId: '2',
      productName: 'Fixed Deposit',
      amount: 250000,
      targetAmount: 2000000,
      monthlyContribution: 50000,
      frequency: 'Monthly',
      duration: '6 Months',
      createdAt: DateTime.now(),
    ),
    SavingsPlan(
      id: 'seed-3',
      name: 'Education Plan',
      productId: '3',
      productName: 'Education Savings',
      amount: 180000,
      targetAmount: 800000,
      monthlyContribution: 15000,
      frequency: 'Monthly',
      duration: 'Flexible',
      createdAt: DateTime.now(),
    ),
  ];

  Future<void> _ensureOnline() async {
    if (forceOffline || !await _networkChecker.isAvailable) {
      throw const NetworkException('No internet connection');
    }
  }

  Future<void> _simulateLatency([Duration? customDuration]) async {
    final d = customDuration ?? latency;
    if (d > Duration.zero) {
      await Future.delayed(d);
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await _ensureOnline();
    await _simulateLatency();

    if (email.trim().toLowerCase() == AppConstants.mockEmail.toLowerCase() &&
        password == AppConstants.mockPassword) {
      return const AuthUser(
        fullName: AppConstants.mockUserName,
        email: AppConstants.mockUserEmail,
        phone: AppConstants.mockUserPhone,
      );
    }
    throw const AuthException('Invalid email or password');
  }

  @override
  Future<List<SavingsProduct>> getSavingsProducts() async {
    await _ensureOnline();
    await _simulateLatency();
    return List.from(_hardcodedProducts);
  }

  @override
  Future<SavingsProduct> getProductById(String id) async {
    await _ensureOnline();
    await _simulateLatency();
    try {
      return _hardcodedProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      throw const ServerException('Product not found');
    }
  }

  @override
  Future<List<SavingsPlan>> getSavingsPlans() async {
    await _ensureOnline();
    await _simulateLatency();
    return List.from(_plans);
  }

  @override
  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    await _ensureOnline();
    await _simulateLatency();

    SavingsProduct product;
    try {
      product = _hardcodedProducts.firstWhere((p) => p.id == productId);
    } catch (_) {
      throw ServerException('Unknown productId: $productId');
    }

    final plan = SavingsPlan(
      id: 'plan-${_plans.length + 1}',
      name: name,
      productId: productId,
      productName: product.name,
      amount: 0,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      frequency: 'Monthly',
      duration: duration,
      createdAt: DateTime.now(),
    );
    _plans.add(plan);
    return plan;
  }

  @override
  Future<List<FinancialTip>> getFinancialTips() async {
    await _ensureOnline();
    await _simulateLatency();
    try {
      final response = await _httpClient.get(
        Uri.parse('${AppConstants.baseUrl}/posts?limit=5'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final posts = (data['posts'] as List<dynamic>?) ?? [];
        return posts.take(3).map((item) {
          final p = item as Map<String, dynamic>;
          return FinancialTip(
            id: p['id'].toString(),
            title: p['title']?.toString() ?? 'Financial Tip',
            body: p['body']?.toString() ?? '',
          );
        }).toList();
      }
      throw ServerException('Failed to load tips (${response.statusCode})');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
