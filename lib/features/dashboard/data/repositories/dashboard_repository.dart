import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/backend_provider.dart';
import '../datasources/tips_remote_data_source.dart';
import '../models/financial_tip.dart';

abstract class DashboardRepository {
  Future<List<FinancialTip>> getTips();
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required TipsRemoteDataSource tipsDataSource,
  }) : _tips = tipsDataSource;

  final TipsRemoteDataSource _tips;

  @override
  Future<List<FinancialTip>> getTips() {
    return _tips.getFinancialTips();
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    tipsDataSource: TipsRemoteDataSourceImpl(ref.watch(backendServiceProvider)),
  );
});

/// Alias for backwards compatibility with tips domain consumers
final tipsRepositoryProvider = dashboardRepositoryProvider;
