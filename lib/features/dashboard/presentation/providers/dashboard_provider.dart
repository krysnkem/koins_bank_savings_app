import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
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
    NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AutoDisposeNotifier<DashboardState> {
  late final DashboardRepository _dashboard;
  late final SavingsRepository _savings;

  @override
  DashboardState build() {
    _dashboard = ref.watch(dashboardRepositoryProvider);
    _savings = ref.watch(savingsRepositoryProvider);
    return const DashboardInitial();
  }

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
      if (e is AppException) {
        state = DashboardError(e.message);
      } else {
        state = DashboardError(e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''));
      }
    }
  }
}
