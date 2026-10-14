import '../../../savings/data/repositories/savings_repository.dart';
import '../datasources/tips_remote_data_source.dart';
import '../models/financial_tip.dart';

abstract class DashboardRepository {
  Future<List<FinancialTip>> getTips();
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required TipsRemoteDataSource tipsDataSource,
    required SavingsRepository savingsRepository,
  })  : _tips = tipsDataSource,
        _savings = savingsRepository;

  final TipsRemoteDataSource _tips;
  final SavingsRepository _savings;

  @override
  Future<List<FinancialTip>> getTips() {
    // TODO: return _tips.getFinancialTips()
    // Recent plans stay on _savings.getPlans(), called by the notifier.
    throw UnimplementedError('TODO $_tips $_savings');
  }
}
