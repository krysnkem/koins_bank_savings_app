import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class SavingsNotifier extends StateNotifier<SavingsState> {
  SavingsNotifier(this._repository) : super(const SavingsInitial());

  final SavingsRepository _repository;

  Future<void> load() async {
    // TODO: emit Loading, _repository.getPlans, Loaded or SavingsError
    throw UnimplementedError('TODO $_repository');
  }

  Future<void> create({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    // TODO: emit Loading, _repository.createPlan, SavingsCreated or SavingsError
    throw UnimplementedError('TODO $_repository');
  }
}
