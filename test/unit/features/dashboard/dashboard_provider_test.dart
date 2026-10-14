import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/models/dummy_post.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:koins_savings_app/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';

class MockDashboardRepository implements DashboardRepository {
  bool shouldFail = false;
  DashboardData mockData = DashboardData(
    totalSavings: 500000.0,
    recentPlans: [
      SavingsPlan(
        id: 'p1',
        name: 'House Rent',
        productId: 'target-savings',
        productName: 'Target Savings',
        amount: 500000,
        targetAmount: 1000000,
        monthlyContribution: 100000,
        frequency: 'Monthly',
        duration: '10 months',
        createdAt: DateTime(2025, 1, 1),
      ),
    ],
    posts: const [
      DummyPost(
        id: 1,
        title: 'His mother had always taught him',
        body: 'His mother had always taught him not to ever think of himself as better than others.',
        tags: ['history'],
        views: 305,
      ),
    ],
  );

  @override
  Future<DashboardData> getDashboardData() async {
    if (shouldFail) {
      throw const NetworkException('Network error occurred');
    }
    return mockData;
  }
}

void main() {
  group('DashboardNotifier & DashboardState', () {
    late ProviderContainer container;
    late MockDashboardRepository mockDashboardRepository;

    setUp(() {
      mockDashboardRepository = MockDashboardRepository();
      container = ProviderContainer(
        overrides: [
          dashboardRepositoryProvider.overrideWithValue(mockDashboardRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is DashboardInitial', () {
      final state = container.read(dashboardNotifierProvider);
      expect(state, isA<DashboardInitial>());
    });

    test('load transitions to DashboardLoading then DashboardLoaded on success', () async {
      final notifier = container.read(dashboardNotifierProvider.notifier);
      final states = <DashboardState>[];

      container.listen(dashboardNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<DashboardLoading>());
      expect(states[1], isA<DashboardLoaded>());
      final loaded = states[1] as DashboardLoaded;
      expect(loaded.totalSavings, 500000.0);
      expect(loaded.recentPlans.length, 1);
      expect(loaded.posts.length, 1);
      expect(loaded.posts.first.title, 'His mother had always taught him');
    });

    test('load transitions to DashboardLoading then DashboardError on failure', () async {
      mockDashboardRepository.shouldFail = true;
      final notifier = container.read(dashboardNotifierProvider.notifier);
      final states = <DashboardState>[];

      container.listen(dashboardNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<DashboardLoading>());
      expect(states[1], isA<DashboardError>());
      expect((states[1] as DashboardError).message, 'Network error occurred');
    });
  });
}
