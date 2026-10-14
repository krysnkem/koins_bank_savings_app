import '../../../../services/backend_service.dart';
import '../models/financial_tip.dart';

abstract class TipsRemoteDataSource {
  Future<List<FinancialTip>> getFinancialTips();
}

class TipsRemoteDataSourceImpl implements TipsRemoteDataSource {
  TipsRemoteDataSourceImpl(this._backend);

  final BackendService _backend;

  @override
  Future<List<FinancialTip>> getFinancialTips() {
    return _backend.getFinancialTips();
  }
}
