import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/primary_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                'JD',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppConstants.mockUserName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(AppConstants.mockUserEmail, style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            const Text(AppConstants.mockUserPhone, style: TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            PrimaryButton(
              label: 'Logout',
              outlined: true,
              icon: const Icon(Icons.logout),
              onPressed: () {
                // EXPECTATION: authProvider.logout() clears the session,
                // then navigate to Login and clear the back stack.
                ref.read(uiSessionProvider.notifier).logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
