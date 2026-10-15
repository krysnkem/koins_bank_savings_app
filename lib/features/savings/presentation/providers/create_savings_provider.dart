import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import 'create_savings_state.dart';
import 'savings_provider.dart';

export 'create_savings_state.dart';

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
      final targetVal = double.tryParse(targetText.replaceAll(',', ''));
      final monthlyVal = double.tryParse(monthlyText.replaceAll(',', ''));

      if (targetVal == null || targetVal <= 0 || monthlyVal == null || monthlyVal <= 0) {
        state = CreateSavingsError(
          'Enter a valid amount',
          productId: state.productId,
          duration: state.duration,
        );
        return;
      }

      if (targetVal < monthlyVal) {
        state = CreateSavingsError(
          'Total target amount cannot be less than monthly amount',
          productId: state.productId,
          duration: state.duration,
        );
        return;
      }

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
        ErrorHandler.getUserMessage(e),
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
