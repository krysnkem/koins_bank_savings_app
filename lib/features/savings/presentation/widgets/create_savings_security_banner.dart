import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Trust and security notice banner on Create Savings screen.
class CreateSavingsSecurityBanner extends StatelessWidget {
  const CreateSavingsSecurityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.35)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.white,
            child: Icon(
              Icons.verified_user_outlined,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Your savings plan helps you stay consistent and achieve your financial goals.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
