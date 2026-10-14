import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/savings/data/datasources/savings_local_data_source.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SavingsLocalDataSourceImpl (Disk Persistence)', () {
    late SavingsLocalDataSource localDataSource;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      localDataSource = SavingsLocalDataSourceImpl();
    });

    test('getPlans returns empty list when no data is written to disk', () async {
      final plans = await localDataSource.getPlans();
      expect(plans, isEmpty);
    });

    test('addPlan writes created savings plan directly to disk (SharedPreferences)', () async {
      final newPlan = SavingsPlan(
        id: 'plan-101',
        name: 'Dream Car Fund',
        productId: '1',
        productName: 'Target Savings',
        amount: 0,
        targetAmount: 3500000,
        monthlyContribution: 150000,
        frequency: 'Monthly',
        duration: '24 Months',
        createdAt: DateTime(2026, 10, 14),
      );

      // Write to disk
      await localDataSource.addPlan(newPlan);

      // Read directly from disk
      final storedPlans = await localDataSource.getPlans();
      expect(storedPlans.length, 1);
      expect(storedPlans.first.id, 'plan-101');
      expect(storedPlans.first.name, 'Dream Car Fund');
      expect(storedPlans.first.targetAmount, 3500000);
      expect(storedPlans.first.monthlyContribution, 150000);
      expect(storedPlans.first.productName, 'Target Savings');
    });

    test('addPlan preserves existing plans and prepends new plan to disk', () async {
      final planA = SavingsPlan(
        id: 'plan-a',
        name: 'Emergency Savings',
        productId: '1',
        productName: 'Target Savings',
        amount: 50000,
        targetAmount: 200000,
        monthlyContribution: 20000,
        frequency: 'Monthly',
        duration: '12 Months',
        createdAt: DateTime(2026, 1, 1),
      );

      final planB = SavingsPlan(
        id: 'plan-b',
        name: 'House Renovation',
        productId: '2',
        productName: 'Fixed Deposit',
        amount: 0,
        targetAmount: 1500000,
        monthlyContribution: 75000,
        frequency: 'Monthly',
        duration: '6 Months',
        createdAt: DateTime(2026, 2, 1),
      );

      await localDataSource.addPlan(planA);
      await localDataSource.addPlan(planB);

      final storedPlans = await localDataSource.getPlans();
      expect(storedPlans.length, 2);
      expect(storedPlans.map((p) => p.id), containsAll(['plan-a', 'plan-b']));
    });

    test('savePlans overwrites and restores full list on disk', () async {
      final list = [
        SavingsPlan(
          id: 'seed-1',
          name: 'College Fund',
          productId: '3',
          productName: 'Education Savings',
          amount: 100000,
          targetAmount: 500000,
          monthlyContribution: 25000,
          frequency: 'Monthly',
          duration: 'Flexible',
          createdAt: DateTime(2026, 5, 1),
        ),
      ];

      await localDataSource.savePlans(list);
      final restored = await localDataSource.getPlans();
      expect(restored.length, 1);
      expect(restored.first.name, 'College Fund');
    });
  });
}
