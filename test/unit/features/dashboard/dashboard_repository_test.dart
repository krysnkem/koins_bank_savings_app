import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/models/financial_tip.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/tips_repository.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';
import 'package:koins_savings_app/features/savings/data/repositories/savings_repository.dart';

class FakeSavingsRepository implements SavingsRepository {
  bool shouldFail = false;
  List<SavingsPlan> plans = [
    SavingsPlan(
      id: 'p1',
      name: 'Emergency',
      productId: 'target-savings',
      productName: 'Target Savings',
      amount: 150000,
      targetAmount: 500000,
      monthlyContribution: 50000,
      frequency: 'Monthly',
      duration: '10 months',
      createdAt: DateTime(2025, 1, 1),
    ),
    SavingsPlan(
      id: 'p2',
      name: 'Car',
      productId: 'target-savings',
      productName: 'Target Savings',
      amount: 250000,
      targetAmount: 2000000,
      monthlyContribution: 100000,
      frequency: 'Monthly',
      duration: '20 months',
      createdAt: DateTime(2025, 2, 1),
    ),
    SavingsPlan(
      id: 'p3',
      name: 'Holiday',
      productId: 'halal-savings',
      productName: 'Halal Savings',
      amount: 50000,
      targetAmount: 300000,
      monthlyContribution: 30000,
      frequency: 'Monthly',
      duration: '10 months',
      createdAt: DateTime(2025, 3, 1),
    ),
    SavingsPlan(
      id: 'p4',
      name: 'Gadget',
      productId: 'fixed-lock',
      productName: 'Fixed Lock',
      amount: 10000,
      targetAmount: 150000,
      monthlyContribution: 15000,
      frequency: 'Monthly',
      duration: '10 months',
      createdAt: DateTime(2025, 4, 1),
    ),
  ];

  @override
  Future<List<SavingsPlan>> getPlans() async {
    if (shouldFail) throw const NetworkException('Failed to load plans');
    return plans;
  }

  @override
  Future<SavingsPlan> createPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    throw UnimplementedError();
  }
}

class FakeTipsRepository implements TipsRepository {
  bool shouldFail = false;
  List<FinancialTip> tips = const [
    FinancialTip(
      id: 'tip-1',
      title: 'Pay Yourself First',
      body: 'Always save before you spend.',
    ),
  ];

  @override
  Future<List<FinancialTip>> getTips() async {
    if (shouldFail) throw const NetworkException('Failed to load tips');
    return tips;
  }
}

void main() {
  late FakeSavingsRepository savingsRepo;
  late FakeTipsRepository tipsRepo;
  late DashboardRepository dashboardRepo;

  setUp(() {
    savingsRepo = FakeSavingsRepository();
    tipsRepo = FakeTipsRepository();
    dashboardRepo = DashboardRepositoryImpl(
      savingsRepository: savingsRepo,
      tipsRepository: tipsRepo,
    );
  });

  group('DashboardRepository.getDashboardData', () {
    test('aggregates savings and tips with total calculated and top 3 plans', () async {
      final data = await dashboardRepo.getDashboardData();

      expect(data.totalSavings, 460000.0); // 150000 + 250000 + 50000 + 10000
      expect(data.recentPlans.length, 3); // capped at 3
      expect(data.recentPlans.first.name, 'Emergency');
      expect(data.tips.length, 1);
      expect(data.tips.first.title, 'Pay Yourself First');
    });

    test('recovers gracefully with empty tips if tipsRepo throws', () async {
      tipsRepo.shouldFail = true;

      final data = await dashboardRepo.getDashboardData();

      expect(data.totalSavings, 460000.0);
      expect(data.recentPlans.length, 3);
      expect(data.tips, isEmpty);
    });

    test('throws exception if savingsRepo fails', () async {
      savingsRepo.shouldFail = true;

      expect(
        () => dashboardRepo.getDashboardData(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
