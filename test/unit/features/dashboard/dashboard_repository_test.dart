import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/models/dummy_post.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/posts_repository.dart';
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

class FakePostsRepository implements PostsRepository {
  bool shouldFail = false;
  List<DummyPost> posts = const [
    DummyPost(
      id: 1,
      title: 'His mother had always taught him',
      body: 'His mother had always taught him not to ever think of himself as better than others.',
      tags: ['history'],
      views: 305,
    ),
  ];

  @override
  Future<List<DummyPost>> getPosts() async {
    if (shouldFail) throw const NetworkException('Failed to load posts');
    return posts;
  }
}

void main() {
  late FakeSavingsRepository savingsRepo;
  late FakePostsRepository postsRepo;
  late DashboardRepository dashboardRepo;

  setUp(() {
    savingsRepo = FakeSavingsRepository();
    postsRepo = FakePostsRepository();
    dashboardRepo = DashboardRepositoryImpl(
      savingsRepository: savingsRepo,
      postsRepository: postsRepo,
    );
  });

  group('DashboardRepository.getDashboardData', () {
    test('aggregates savings and posts with total calculated and top 3 plans', () async {
      final data = await dashboardRepo.getDashboardData();

      expect(data.totalSavings, 460000.0); // 150000 + 250000 + 50000 + 10000
      expect(data.recentPlans.length, 3); // capped at 3
      expect(data.recentPlans.first.name, 'Emergency');
      expect(data.posts.length, 1);
      expect(data.posts.first.title, 'His mother had always taught him');
    });

    test('recovers gracefully with empty posts if postsRepo throws', () async {
      postsRepo.shouldFail = true;

      final data = await dashboardRepo.getDashboardData();

      expect(data.totalSavings, 460000.0);
      expect(data.recentPlans.length, 3);
      expect(data.posts, isEmpty);
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
