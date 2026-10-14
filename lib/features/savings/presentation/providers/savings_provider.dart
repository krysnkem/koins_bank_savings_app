import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/mock_backend_service.dart';
import '../../data/datasources/savings_local_data_source.dart';
import '../../data/datasources/savings_remote_data_source.dart';
import '../../data/models/savings_plan.dart';
import '../../data/repositories/savings_repository.dart';

sealed class SavingsState {
  const SavingsState();
}

class SavingsInitial extends SavingsState {
  const SavingsInitial();
}

class SavingsLoading extends SavingsState {
  const SavingsLoading();
}

class SavingsLoaded extends SavingsState {
  final List<SavingsPlan> plans;
  const SavingsLoaded(this.plans);
}

class SavingsCreated extends SavingsState {
  final SavingsPlan plan;
  const SavingsCreated(this.plan);
}

class SavingsError extends SavingsState {
  final String message;
  const SavingsError(this.message);
}

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepositoryImpl(
    remoteDataSource: SavingsRemoteDataSourceImpl(MockBackendService()),
    localDataSource: SavingsLocalDataSourceImpl(),
  );
});

final savingsNotifierProvider =
    StateNotifierProvider<SavingsNotifier, SavingsState>((ref) {
  final repo = ref.watch(savingsRepositoryProvider);
  return SavingsNotifier(repo);
});

class SavingsNotifier extends StateNotifier<SavingsState> {
  SavingsNotifier(this._repository) : super(const SavingsInitial());

  final SavingsRepository _repository;

  Future<void> load() async {
    state = const SavingsLoading();
    try {
      final plans = await _repository.getPlans();
      state = SavingsLoaded(plans);
    } catch (e) {
      state = SavingsError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<SavingsPlan?> create({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    state = const SavingsLoading();
    try {
      final plan = await _repository.createPlan(
        name: name,
        productId: productId,
        targetAmount: targetAmount,
        monthlyContribution: monthlyContribution,
        duration: duration,
      );
      final updatedPlans = await _repository.getPlans();
      state = SavingsLoaded(updatedPlans);
      return plan;
    } catch (e) {
      state = SavingsError(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }
}
