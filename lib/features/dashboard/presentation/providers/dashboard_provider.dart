import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/data/repositories/savings_repository.dart';
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
    // TODO: emit Loading
    // TODO: recent = await _savings.getPlans() (take 3)
    // TODO: tips = await _dashboard.getTips()
    // TODO: emit DashboardLoaded or DashboardError
    throw UnimplementedError('TODO $_dashboard $_savings');
  }
}
