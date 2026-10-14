import '../datasources/savings_local_data_source.dart';
import '../datasources/savings_remote_data_source.dart';
import '../models/savings_plan.dart';

abstract class SavingsRepository {
  Future<List<SavingsPlan>> getPlans();

  Future<SavingsPlan> createPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  });
}

class SavingsRepositoryImpl implements SavingsRepository {
  SavingsRepositoryImpl({
    required SavingsRemoteDataSource remoteDataSource,
    required SavingsLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final SavingsRemoteDataSource _remote;
  final SavingsLocalDataSource _local;

  @override
  Future<List<SavingsPlan>> getPlans() async {
    // TODO: plans = await _remote.getSavingsPlans()
    // TODO: await _local.savePlans(plans) then return plans
    throw UnimplementedError('TODO $_remote $_local');
  }

  @override
  Future<SavingsPlan> createPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    // TODO: plan = await _remote.createSavingsPlan(...)
    // TODO: await _local.addPlan(plan) only after success
    // TODO: rethrow NetworkException without writing locally
    throw UnimplementedError('TODO $_remote $_local');
  }
}
