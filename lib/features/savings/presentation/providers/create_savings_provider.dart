import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/savings_plan.dart';
import 'savings_provider.dart';

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

class CreateSavingsNotifier
    extends AutoDisposeFamilyNotifier<CreateSavingsState, String?> {
  @override
  CreateSavingsState build(String? arg) {
    return CreateSavingsInitial(productId: arg);
  }

  void selectProduct(String? productId) {
    state = _copyWith(productId: productId);
  }

  void selectDuration(String? duration) {
    state = _copyWith(duration: duration);
  }

  CreateSavingsState _copyWith({String? productId, String? duration}) {
    final pId = productId ?? state.productId;
    final dur = duration ?? state.duration;
    return switch (state) {
      CreateSavingsInitial() =>
        CreateSavingsInitial(productId: pId, duration: dur),
      CreateSavingsLoading() =>
        CreateSavingsLoading(productId: pId, duration: dur),
      CreateSavingsSuccess(:final plan) =>
        CreateSavingsSuccess(plan: plan, productId: pId, duration: dur),
      CreateSavingsError(:final message) =>
        CreateSavingsError(message, productId: pId, duration: dur),
    };
  }

  Future<void> submit({
    required GlobalKey<FormState> formKey,
    required String name,
    required String targetText,
    required String monthlyText,
  }) async {
    if (!formKey.currentState!.validate()) return;
    if (state.productId == null || state.duration == null) {
      state = CreateSavingsError(
        'Select a product and duration',
        productId: state.productId,
        duration: state.duration,
      );
      return;
    }

    state = CreateSavingsLoading(
      productId: state.productId,
      duration: state.duration,
    );

    try {
      final targetVal = double.parse(targetText.replaceAll(',', ''));
      final monthlyVal = double.parse(monthlyText.replaceAll(',', ''));

      final plan = await ref.read(savingsNotifierProvider.notifier).create(
            name: name.trim(),
            productId: state.productId!,
            targetAmount: targetVal,
            monthlyContribution: monthlyVal,
            duration: state.duration!,
          );

      if (plan == null) {
        final savingsState = ref.read(savingsNotifierProvider);
        final err = savingsState is SavingsError
            ? savingsState.message
            : 'Failed to create plan';
        state = CreateSavingsError(
          err,
          productId: state.productId,
          duration: state.duration,
        );
        return;
      }

      state = CreateSavingsSuccess(
        plan: plan,
        productId: state.productId,
        duration: state.duration,
      );
    } catch (e) {
      state = CreateSavingsError(
        e.toString(),
        productId: state.productId,
        duration: state.duration,
      );
    }
  }
}

final createSavingsNotifierProvider = NotifierProvider.autoDispose
    .family<CreateSavingsNotifier, CreateSavingsState, String?>(
  CreateSavingsNotifier.new,
);
