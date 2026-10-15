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

    testWidgets('does not re-trigger animation when updated with the same amount', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 100000,
              isLoaded: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('₦100,000'), findsOneWidget);

      // Rebuild with same amount
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredRollingNumber(
              amount: 100000,
              isLoaded: true,
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Pump 1 frame – numbers should already be at final settled digits without re-rolling from 0
      await tester.pump();
      expect(find.bySemanticsLabel('₦100,000'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('retains state when scrolled off-screen and back in a ListView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                const StaggeredRollingNumber(
                  amount: 750000,
                  isLoaded: true,
                  duration: Duration(milliseconds: 200),
                ),
                Container(height: 2000, color: Colors.blue),
                const Text('Bottom Marker'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('₦750,000'), findsOneWidget);

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(find.text('Bottom Marker'), findsOneWidget);

      // Scroll back to top
      await tester.drag(find.byType(ListView), const Offset(0, 1500));
      await tester.pump();

      // Number should be intact and not reset
      expect(find.bySemanticsLabel('₦750,000'), findsOneWidget);
      expect(find.text('7'), findsWidgets);
    });
  });
}
