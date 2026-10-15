import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';
import 'package:koins_savings_app/features/savings/presentation/providers/create_savings_provider.dart';
import 'package:koins_savings_app/features/savings/presentation/providers/savings_provider.dart';

// Mock Notifier for savingsNotifierProvider
class FakeSavingsNotifier extends SavingsNotifier {
  @override
  SavingsState build() => const SavingsLoaded([]);

  @override
  Future<SavingsPlan?> create({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  }) async {
    return SavingsPlan(
      id: 'plan-123',
      name: name,
      productId: productId,
      productName: 'Target Savings',
      amount: 0.0,
      targetAmount: targetAmount,
      monthlyContribution: monthlyContribution,
      frequency: 'Monthly',
      duration: duration,
      createdAt: DateTime.now(),
    );
  }
}

void main() {
  test('CreateSavingsNotifier initializes with optional productId', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(createSavingsNotifierProvider('1'));
    expect(state, isA<CreateSavingsInitial>());
    expect(state.productId, '1');
    expect(state.duration, isNull);
  });

  test('CreateSavingsNotifier updates productId and duration selection', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(createSavingsNotifierProvider(null).notifier);
    notifier.selectProduct('2');
    notifier.selectDuration('6 Months');

    final state = container.read(createSavingsNotifierProvider(null));
    expect(state.productId, '2');
    expect(state.duration, '6 Months');
  });

  testWidgets('CreateSavingsNotifier rejects submit when target < monthly contribution', (tester) async {
    final container = ProviderContainer(
      overrides: [
        savingsNotifierProvider.overrideWith(FakeSavingsNotifier.new),
      ],
    );
    addTearDown(container.dispose);

    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final notifier = container.read(createSavingsNotifierProvider('1').notifier);
    final subscription = container.listen(createSavingsNotifierProvider('1'), (_, __) {});
    addTearDown(subscription.close);

    notifier.selectProduct('1');
    notifier.selectDuration('12 Months');

    await notifier.submit(
      formKey: formKey,
      name: 'Holiday Trip',
      targetText: '50,000',
      monthlyText: '100,000',
    );

    final state = container.read(createSavingsNotifierProvider('1'));
    expect(state, isA<CreateSavingsError>());
    expect(
      (state as CreateSavingsError).message,
      'Total target amount cannot be less than monthly amount',
    );
    await tester.pumpAndSettle();
  });

  testWidgets('CreateSavingsNotifier successfully creates plan when target >= monthly', (tester) async {
    final container = ProviderContainer(
      overrides: [
        savingsNotifierProvider.overrideWith(FakeSavingsNotifier.new),
      ],
    );
    addTearDown(container.dispose);

    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final notifier = container.read(createSavingsNotifierProvider('1').notifier);
    final subscription = container.listen(createSavingsNotifierProvider('1'), (_, __) {});
    addTearDown(subscription.close);

    notifier.selectProduct('1');
    notifier.selectDuration('12 Months');

    await notifier.submit(
      formKey: formKey,
      name: 'Tech Freelance Buffer',
      targetText: '1,500,000',
      monthlyText: '100,000',
    );

    final state = container.read(createSavingsNotifierProvider('1'));
    expect(state, isA<CreateSavingsSuccess>());
    final success = state as CreateSavingsSuccess;
    expect(success.plan.targetAmount, 1500000);
    expect(success.plan.monthlyContribution, 100000);
    await tester.pumpAndSettle();
  });
}
