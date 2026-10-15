import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/widgets/common/app_shimmer.dart';

void main() {
  group('AppShimmer Widget Tests', () {
    testWidgets('renders basic AppShimmer with specified dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppShimmer(
              width: 100,
              height: 20,
            ),
          ),
        ),
      );

      expect(find.byType(AppShimmer), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('renders AppShimmer.circle and AppShimmer.card constructors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppShimmer.circle(size: 40),
                AppShimmer.card(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(AppShimmer), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('renders PostCardShimmer skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PostCardShimmer(),
          ),
        ),
      );

      expect(find.byType(PostCardShimmer), findsOneWidget);
      expect(find.byType(AppShimmer), findsNWidgets(3)); // circle + 2 lines
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('renders RecentSavingsCardShimmer skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecentSavingsCardShimmer(),
          ),
        ),
      );

      expect(find.byType(RecentSavingsCardShimmer), findsOneWidget);
      expect(find.byType(AppShimmer), findsNWidgets(4)); // circle + 2 lines + amount
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
