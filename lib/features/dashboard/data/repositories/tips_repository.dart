import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/backend_provider.dart';
import '../datasources/tips_remote_data_source.dart';
import '../models/financial_tip.dart';

abstract class TipsRepository {
  Future<List<FinancialTip>> getTips();
}

class TipsRepositoryImpl implements TipsRepository {
  TipsRepositoryImpl({
    required TipsRemoteDataSource tipsDataSource,
  }) : _tipsDataSource = tipsDataSource;

  final TipsRemoteDataSource _tipsDataSource;

  @override
  Future<List<FinancialTip>> getTips() {
    return _tipsDataSource.getFinancialTips();
  }
}

final tipsRepositoryProvider = Provider<TipsRepository>((ref) {
  return TipsRepositoryImpl(
    tipsDataSource: TipsRemoteDataSourceImpl(ref.watch(backendServiceProvider)),
  );
});
