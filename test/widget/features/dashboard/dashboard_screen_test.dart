import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:koins_savings_app/features/dashboard/presentation/widgets/dashboard_header_section.dart';
import 'package:koins_savings_app/features/dashboard/presentation/widgets/dashboard_quick_actions_section.dart';
import 'package:koins_savings_app/features/dashboard/presentation/widgets/dashboard_recent_savings_section.dart';
import 'package:koins_savings_app/features/dashboard/presentation/widgets/dashboard_tips_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('DashboardScreen renders all componentized sections cleanly', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify all 4 sections exist
    expect(find.byType(DashboardHeaderSection), findsOneWidget);
    expect(find.byType(DashboardQuickActionsSection), findsOneWidget);
    expect(find.byType(DashboardRecentSavingsSection), findsOneWidget);
    expect(find.byType(DashboardTipsSection), findsOneWidget);

    // Verify header content
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Total Savings'), findsOneWidget);

    // Verify quick action buttons
    expect(find.text('Create Savings'), findsOneWidget);
    expect(find.text('View Products'), findsOneWidget);

    // Verify recent savings section
    expect(find.text('Recent Savings'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);

    // Verify financial tips section
    expect(find.text('Financial Tips'), findsOneWidget);
  });
}
