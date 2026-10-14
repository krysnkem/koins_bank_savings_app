import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/savings/presentation/screens/savings_plans_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SavingsPlansScreen renders portfolio and plans list', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SavingsPlansScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Savings'), findsOneWidget);
    expect(find.text('Savings Portfolio'), findsOneWidget);
    expect(find.text('Active Savings Plans'), findsOneWidget);
  });
}
