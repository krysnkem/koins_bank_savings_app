import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/data/repositories/savings_repository.dart';
import '../../data/models/financial_tip.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

export 'dashboard_state.dart';
export 'tips_provider.dart';

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
      final totalSavings = allPlans.fold<double>(
        0.0,
        (sum, p) => sum + p.amount,
      );

      state = DashboardLoaded(
        totalSavings: totalSavings,
        recentPlans: allPlans.take(3).toList(),
        tips: tips,
      );
    } catch (e) {
      if (e is AppException) {
        state = DashboardError(e.message);
      } else {
        state = DashboardError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }
}
