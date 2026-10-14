import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/constants/app_constants.dart';
import 'package:koins_savings_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:koins_savings_app/features/auth/presentation/widgets/profile_avatar_header.dart';
import 'package:koins_savings_app/features/auth/presentation/widgets/profile_info_section.dart';
import 'package:koins_savings_app/features/auth/presentation/widgets/profile_logout_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ProfileScreen renders avatar, info section, and logout button', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ProfileAvatarHeader), findsOneWidget);
    expect(find.byType(ProfileInfoSection), findsOneWidget);
    expect(find.byType(ProfileLogoutButton), findsOneWidget);
    expect(find.text(AppConstants.mockUserName), findsOneWidget);
    expect(find.text(AppConstants.mockUserEmail), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
