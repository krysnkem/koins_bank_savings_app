import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/constants/latency_constants.dart';
import 'package:koins_savings_app/features/savings/data/datasources/savings_local_data_source.dart';
import 'package:koins_savings_app/features/savings/presentation/screens/create_savings_screen.dart';
import 'package:koins_savings_app/services/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    LatencyConstants.disableForTesting();
    await AppDatabase.instance.database;
  });

  testWidgets('CreateSavingsScreen creates savings plan and writes to disk', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final localDataSource = SavingsLocalDataSourceImpl();

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CreateSavingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial fields
    expect(find.text('Create Savings Plan'), findsWidgets);
    expect(find.text('Savings Name'), findsOneWidget);
    expect(find.text('Target Amount'), findsOneWidget);
    expect(find.text('Monthly Contribution'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);

    // Enter name
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'Tech Freelance Buffer');
    await tester.pumpAndSettle();

    // Select Product Type
    final dropdowns = find.byType(DropdownButtonFormField<String>);
    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Target Savings (12%)').last);
    await tester.pumpAndSettle();

    // Enter Target Amount and Monthly Contribution
    await tester.enterText(textFields.at(1), '1500000');
    await tester.enterText(textFields.at(2), '100000');
    await tester.pumpAndSettle();

    // Select Duration
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12 Months').last);
    await tester.pumpAndSettle();

    // Tap Create button
    final createBtn = find.text('Create');
    await tester.ensureVisible(createBtn);
    await tester.tap(createBtn);
    await tester.pumpAndSettle();

    // Verify Success SnackBar
    expect(find.text('Savings Created Successfully'), findsOneWidget);

    // Verify that data is actually written to disk in SharedPreferences
    final storedPlans = await localDataSource.getPlans();
    expect(storedPlans, isNotEmpty);
    expect(storedPlans.any((p) => p.name == 'Tech Freelance Buffer'), isTrue);
    final bufferPlan = storedPlans.firstWhere((p) => p.name == 'Tech Freelance Buffer');
    expect(bufferPlan.targetAmount, 1500000);
    expect(bufferPlan.monthlyContribution, 100000);
    expect(bufferPlan.duration, '12 Months');
  });

  testWidgets('Amount fields format digits with comma thousands separators dynamically', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CreateSavingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);
    final targetField = textFields.at(1);
    final monthlyField = textFields.at(2);

    // Type 100000 into target field
    await tester.enterText(targetField, '100000');
    await tester.pumpAndSettle();
    expect(find.text('100,000'), findsOneWidget);

    // Type 2500000 into monthly field
    await tester.enterText(monthlyField, '2500000');
    await tester.pumpAndSettle();
    expect(find.text('2,500,000'), findsOneWidget);
  });

  testWidgets('Validation prevents submission if target amount is less than monthly contribution', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CreateSavingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);
    final dropdowns = find.byType(DropdownButtonFormField<String>);

    // Enter name
    await tester.enterText(textFields.at(0), 'Holiday Car');
    await tester.pumpAndSettle();

    // Select Product
    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Target Savings (12%)').last);
    await tester.pumpAndSettle();

    // Select Duration
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12 Months').last);
    await tester.pumpAndSettle();

    // Enter Target Amount: 50,000 and Monthly Contribution: 100,000 (Target < Monthly)
    await tester.enterText(textFields.at(1), '50000');
    await tester.enterText(textFields.at(2), '100000');
    await tester.pumpAndSettle();

    // Tap Create button
    final createBtn = find.text('Create');
    await tester.ensureVisible(createBtn);
    await tester.tap(createBtn);
    await tester.pumpAndSettle();

    // Should show validation error and NOT create
    expect(
      find.text('Total target amount cannot be less than monthly amount'),
      findsOneWidget,
    );
    expect(find.text('Savings Created Successfully'), findsNothing);

    // Now update Target Amount to 200,000 (>= Monthly Contribution 100,000)
    await tester.enterText(textFields.at(1), '200000');
    await tester.pumpAndSettle();

    // Error message should disappear
    expect(
      find.text('Total target amount cannot be less than monthly amount'),
      findsNothing,
    );

    // Tap Create button again
    await tester.tap(createBtn);
    await tester.pumpAndSettle();

    // Success SnackBar should appear
    expect(find.text('Savings Created Successfully'), findsOneWidget);
  });
}
