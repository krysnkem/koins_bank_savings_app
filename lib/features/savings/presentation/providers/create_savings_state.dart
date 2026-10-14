import '../../data/models/savings_plan.dart';

sealed class CreateSavingsState {
  final String? productId;
  final String? duration;

  const CreateSavingsState({
    this.productId,
    this.duration,
  });

  bool get isLoading => this is CreateSavingsLoading;
}

class CreateSavingsInitial extends CreateSavingsState {
  const CreateSavingsInitial({super.productId, super.duration});
}

class CreateSavingsLoading extends CreateSavingsState {
  const CreateSavingsLoading({super.productId, super.duration});
}

class CreateSavingsSuccess extends CreateSavingsState {
  final SavingsPlan plan;
  const CreateSavingsSuccess({
    required this.plan,
    super.productId,
    super.duration,
  });
}

class CreateSavingsError extends CreateSavingsState {
  final String message;
  const CreateSavingsError(
    this.message, {
    super.productId,
    super.duration,
  });
}
