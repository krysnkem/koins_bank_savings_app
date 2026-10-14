import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/staggered_rolling_number.dart';

void main() {
  group('StaggeredRollingNumber Widget Tests', () {
    testWidgets('renders currency symbol and digits cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 250000,
              isLoaded: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Verify Semantics label matches formatted currency string
      expect(find.bySemanticsLabel('₦250,000'), findsOneWidget);

      // Static characters
      expect(find.text('₦'), findsOneWidget);
      expect(find.text(','), findsOneWidget);

      // Settle animation
      await tester.pumpAndSettle();

      // Verify the final settled digits are displayed
      expect(find.text('2'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('handles zero amount without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 0,
              isLoaded: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('₦0'), findsOneWidget);
      expect(find.text('₦'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('staggered animation runs when isLoaded becomes true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 50000,
              isLoaded: false,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('₦0'), findsOneWidget);

      // Update to isLoaded: true
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 50000,
              isLoaded: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Check that it updates to ₦50,000 and animates
      expect(find.bySemanticsLabel('₦50,000'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('5'), findsWidgets);
    });
  });
}
