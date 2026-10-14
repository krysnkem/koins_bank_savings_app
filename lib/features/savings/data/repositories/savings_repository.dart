import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/backend_provider.dart';
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
    final localPlans = await _local.getPlans();
    if (localPlans.isNotEmpty) {
      return localPlans;
    }
    final plans = await _remote.getSavingsPlans();
    await _local.savePlans(plans);
    return plans;
  }

  @override
  Future<SavingsPlan> createPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    final plan = await _remote.createSavingsPlan(
      name: name,
      productId: productId,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      duration: duration,
    );
    await _local.addPlan(plan);
    return plan;
  }
}

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepositoryImpl(
    remoteDataSource: SavingsRemoteDataSourceImpl(ref.watch(backendServiceProvider)),
    localDataSource: SavingsLocalDataSourceImpl(),
  );
});
