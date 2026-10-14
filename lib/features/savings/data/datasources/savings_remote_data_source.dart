import '../../../../services/backend_service.dart';
import '../models/savings_plan.dart';

abstract class SavingsRemoteDataSource {
  Future<List<SavingsPlan>> getSavingsPlans();

  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  });
}

class SavingsRemoteDataSourceImpl implements SavingsRemoteDataSource {
  SavingsRemoteDataSourceImpl(this._backend);

  final BackendService _backend;

  @override
  Future<List<SavingsPlan>> getSavingsPlans() {
    // TODO: return _backend.getSavingsPlans()
    throw UnimplementedError('TODO $_backend');
  }

  @override
  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) {
    // TODO: return _backend.createSavingsPlan(...)
    throw UnimplementedError('TODO $_backend');
  }
}
