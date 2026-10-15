import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/savings_plan.dart';
import '../../data/repositories/savings_repository.dart';
import 'savings_state.dart';

export 'savings_state.dart';

final savingsNotifierProvider =
    NotifierProvider<SavingsNotifier, SavingsState>(SavingsNotifier.new);

class SavingsNotifier extends Notifier<SavingsState> {
  late final SavingsRepository _repository;

  @override
  SavingsState build() {
    _repository = ref.watch(savingsRepositoryProvider);
    return const SavingsInitial();
  }

  Future<void> load({bool force = false}) async {
    if (!force && state is SavingsLoaded) {
      return;
    }
    state = const SavingsLoading();
    try {
      final plans = await _repository.getPlans();
      state = SavingsLoaded(plans);
    } catch (e) {
      state = SavingsError(ErrorHandler.getUserMessage(e));
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
      state = SavingsError(ErrorHandler.getUserMessage(e));
      return null;
    }
  }
}
