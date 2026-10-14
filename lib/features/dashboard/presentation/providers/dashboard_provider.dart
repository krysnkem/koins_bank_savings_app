import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/mock_backend_service.dart';
import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/data/repositories/savings_repository.dart';
import '../../../savings/presentation/providers/savings_provider.dart';
import '../../data/datasources/tips_remote_data_source.dart';
import '../../data/models/financial_tip.dart';
import '../../data/repositories/dashboard_repository.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<SavingsPlan> recentPlans;
  final List<FinancialTip> tips;
  const DashboardLoaded({required this.recentPlans, required this.tips});
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    tipsDataSource: TipsRemoteDataSourceImpl(MockBackendService()),
  );
});

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final dashboardRepo = ref.watch(dashboardRepositoryProvider);
  final savingsRepo = ref.watch(savingsRepositoryProvider);
  return DashboardNotifier(
    dashboardRepository: dashboardRepo,
    savingsRepository: savingsRepo,
  );
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier({
    required DashboardRepository dashboardRepository,
    required SavingsRepository savingsRepository,
  })  : _dashboard = dashboardRepository,
        _savings = savingsRepository,
        super(const DashboardInitial());

  final DashboardRepository _dashboard;
  final SavingsRepository _savings;

  Future<void> load() async {
    state = const DashboardLoading();
    try {
      final results = await Future.wait([
        _savings.getPlans(),
        _dashboard.getTips().catchError((_) => <FinancialTip>[]),
      ]);

      final allPlans = results[0] as List<SavingsPlan>;
      final tips = results[1] as List<FinancialTip>;

      state = DashboardLoaded(
        recentPlans: allPlans.take(3).toList(),
        tips: tips,
      );
    } catch (e) {
      state = DashboardError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
