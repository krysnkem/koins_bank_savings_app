import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/savings/data/datasources/savings_local_data_source.dart';
import 'package:koins_savings_app/features/savings/data/datasources/savings_remote_data_source.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';
import 'package:koins_savings_app/features/savings/data/repositories/savings_repository.dart';

class FakeSavingsRemoteDataSource implements SavingsRemoteDataSource {
  FakeSavingsRemoteDataSource({this.networkError = false});

  bool networkError;
  final List<SavingsPlan> _plans = [];

  @override
  Future<List<SavingsPlan>> getSavingsPlans() async {
    if (networkError) throw const NetworkException();
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
    if (networkError) throw const NetworkException();
    final plan = SavingsPlan(
      id: 'plan-${_plans.length + 1}',
      name: name,
      productId: productId,
      productName: 'Target Savings',
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
}

class FakeSavingsLocalDataSource implements SavingsLocalDataSource {
  final List<SavingsPlan> _cached = [];

  @override
  Future<void> savePlans(List<SavingsPlan> plans) async {
    _cached
      ..clear()
      ..addAll(plans);
  }

  @override
  Future<List<SavingsPlan>> getPlans() async => List.from(_cached);

  @override
  Future<void> addPlan(SavingsPlan plan) async => _cached.add(plan);
}

void main() {
  late FakeSavingsRemoteDataSource remote;
  late FakeSavingsLocalDataSource local;
  late SavingsRepository repository;

  setUp(() {
    remote = FakeSavingsRemoteDataSource();
    local = FakeSavingsLocalDataSource();
    repository = SavingsRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
    );
  });

  group('SavingsRepository.createPlan', () {
    test('creates plan via remote and persists locally', () async {
      final plan = await repository.createPlan(
        name: 'Emergency Fund',
        productId: '1',
        targetAmount: 500000,
        monthlyContribution: 20000,
        duration: '12 Months',
      );

      expect(plan.name, 'Emergency Fund');
      expect(plan.targetAmount, 500000);

      final localPlans = await local.getPlans();
      expect(localPlans, isNotEmpty);
      expect(localPlans.any((p) => p.name == 'Emergency Fund'), isTrue);
    });

    test('propagates NetworkException and does not persist', () async {
      remote.networkError = true;

      expect(
        () => repository.createPlan(
          name: 'Fail Plan',
          productId: '1',
          targetAmount: 10000,
          monthlyContribution: 1000,
          duration: '6 Months',
        ),
        throwsA(isA<NetworkException>()),
      );

      expect(await local.getPlans(), isEmpty);
    });
  });

  group('SavingsRepository.getPlans', () {
    test('returns plans from remote and caches them', () async {
      await remote.createSavingsPlan(
        name: 'Seed Plan',
        productId: '1',
        targetAmount: 100000,
        monthlyContribution: 10000,
        duration: '6 Months',
      );

      final plans = await repository.getPlans();

      expect(plans.length, 1);
      expect(plans.first.name, 'Seed Plan');
    });
  });
}
