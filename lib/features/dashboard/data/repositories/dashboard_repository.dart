import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/data/repositories/savings_repository.dart';
import '../models/financial_tip.dart';
import 'tips_repository.dart';

class DashboardData {
  final double totalSavings;
  final List<SavingsPlan> recentPlans;
  final List<FinancialTip> tips;

  const DashboardData({
    required this.totalSavings,
    required this.recentPlans,
    required this.tips,
  });
}

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required SavingsRepository savingsRepository,
    required TipsRepository tipsRepository,
  })  : _savingsRepository = savingsRepository,
        _tipsRepository = tipsRepository;

  final SavingsRepository _savingsRepository;
  final TipsRepository _tipsRepository;

  @override
  Future<DashboardData> getDashboardData() async {
    final results = await Future.wait([
      _savingsRepository.getPlans(),
      _tipsRepository.getTips().catchError((_) => <FinancialTip>[]),
    ]);

    final allPlans = results[0] as List<SavingsPlan>;
    final tips = results[1] as List<FinancialTip>;
    final totalSavings = allPlans.fold<double>(
      0.0,
      (sum, p) => sum + p.amount,
    );

    return DashboardData(
      totalSavings: totalSavings,
      recentPlans: allPlans.take(3).toList(),
      tips: tips,
    );
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    savingsRepository: ref.watch(savingsRepositoryProvider),
    tipsRepository: ref.watch(tipsRepositoryProvider),
  );
});
