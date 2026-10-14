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
