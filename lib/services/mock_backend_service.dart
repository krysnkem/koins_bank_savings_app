import '../core/constants/latency_constants.dart';
import '../core/errors/app_exception.dart';
import '../core/network/network_checker.dart';
import '../features/auth/data/models/auth_user.dart';
import '../features/dashboard/data/models/financial_tip.dart';
import '../features/dashboard/data/models/transaction_item.dart';
import '../features/products/data/models/savings_product.dart';
import '../features/savings/data/models/savings_plan.dart';
import 'backend_service.dart';
import 'database/app_database.dart';
import 'database/database_service.dart';
import 'database/sqflite_database_service.dart';

/// Simulates a real backend API by querying and persisting data via [DatabaseService],
/// introducing configurable latency and network checking.
class MockBackendService implements BackendService {
  MockBackendService({
    DatabaseService? databaseService,
    NetworkChecker? networkChecker,
    Duration? latency,
  })  : _databaseService = databaseService ?? SqfliteDatabaseService(),
        _networkChecker = networkChecker ?? const NetworkCheckerImpl(),
        latency = latency ?? LatencyConstants.backend;

  final DatabaseService _databaseService;
  final NetworkChecker _networkChecker;

  Duration latency;
  bool forceOffline = false;

  /// User email strictly managed by the backend
  static const String managedUserEmail = AppDatabase.managedUserEmail;

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

    final userRow = await _databaseService.getUserByEmail(email);
    if (userRow != null && userRow['password'] == password) {
      return AuthUser(
        fullName: userRow['full_name']?.toString() ?? '',
        email: userRow['email']?.toString() ?? '',
        phone: userRow['phone']?.toString() ?? '',
      );
    }
    throw const AuthException('Invalid email or password');
  }

  @override
  Future<List<SavingsProduct>> getSavingsProducts() async {
    await _ensureOnline();
    await _simulateLatency();

    final rows = await _databaseService.getSavingsProducts();
    return rows.map((r) {
      return SavingsProduct(
        id: r['id'].toString(),
        name: r['name'].toString(),
        interestRate: (r['interest_rate'] as num).toDouble(),
        duration: r['duration'].toString(),
        shortDescription: r['short_description'].toString(),
        minimumDeposit: (r['minimum_deposit'] as num).toDouble(),
      );
    }).toList();
  }

  @override
  Future<SavingsProduct> getProductById(String id) async {
    await _ensureOnline();
    await _simulateLatency();

    final row = await _databaseService.getProductById(id);
    if (row != null) {
      return SavingsProduct(
        id: row['id'].toString(),
        name: row['name'].toString(),
        interestRate: (row['interest_rate'] as num).toDouble(),
        duration: row['duration'].toString(),
        shortDescription: row['short_description'].toString(),
        minimumDeposit: (row['minimum_deposit'] as num).toDouble(),
      );
    }
    throw const ServerException('Product not found');
  }

  @override
  Future<List<SavingsPlan>> getSavingsPlans() async {
    await _ensureOnline();
    await _simulateLatency();

    final rows = await _databaseService.getSavingsPlans(
      email: managedUserEmail,
    );
    return rows.map((r) {
      return SavingsPlan(
        id: r['id'].toString(),
        name: r['name'].toString(),
        productId: r['product_id'].toString(),
        productName: r['product_name'].toString(),
        amount: (r['amount'] as num).toDouble(),
        targetAmount: (r['target_amount'] as num).toDouble(),
        monthlyContribution: (r['monthly_contribution'] as num).toDouble(),
        frequency: r['frequency'].toString(),
        duration: r['duration'].toString(),
        createdAt: DateTime.tryParse(r['created_at'].toString()) ?? DateTime.now(),
      );
    }).toList();
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

    final productRow = await _databaseService.getProductById(productId);
    if (productRow == null) {
      throw ServerException('Unknown productId: $productId');
    }
    final productName = productRow['name'].toString();

    final now = DateTime.now();
    final planId = 'plan-${now.millisecondsSinceEpoch}';

    final planMap = {
      'id': planId,
      'user_email': managedUserEmail,
      'product_id': productId,
      'product_name': productName,
      'name': name,
      'amount': 0.0,
      'target_amount': targetAmount,
      'monthly_contribution': monthlyContribution,
      'frequency': 'Monthly',
      'duration': duration,
      'status': 'active',
      'created_at': now.toIso8601String(),
    };
    await _databaseService.insertSavingsPlan(planMap);

    // Record creation event in transactions table
    final txMap = {
      'id': 'tx-${now.millisecondsSinceEpoch}',
      'user_email': managedUserEmail,
      'plan_id': planId,
      'title': '$name Plan Created',
      'category': productName,
      'amount': monthlyContribution,
      'is_credit': 1,
      'status': 'Completed',
      'date_label': 'Just now',
      'icon_key': 'shield',
      'created_at': now.toIso8601String(),
    };
    await _databaseService.insertTransaction(txMap);

    return SavingsPlan(
      id: planId,
      name: name,
      productId: productId,
      productName: productName,
      amount: 0.0,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      frequency: 'Monthly',
      duration: duration,
      createdAt: now,
    );
  }

  @override
  Future<List<FinancialTip>> getFinancialTips() async {
    await _ensureOnline();
    await _simulateLatency();

    final rows = await _databaseService.getFinancialTips();
    return rows.map((r) {
      return FinancialTip(
        id: r['id'].toString(),
        title: r['title']?.toString() ?? 'Financial Tip',
        body: r['body']?.toString() ?? '',
      );
    }).toList();
  }

  @override
  Future<List<TransactionItem>> getTransactions() async {
    await _ensureOnline();
    await _simulateLatency();

    final rows = await _databaseService.getTransactions(
      email: managedUserEmail,
    );
    return rows.map(TransactionItem.fromMap).toList();
  }
}
