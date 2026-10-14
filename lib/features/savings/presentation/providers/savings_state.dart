import '../../data/models/savings_plan.dart';

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
