import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

/// Displays the greeting and the user's total savings summary.
class DashboardHeaderSection extends StatelessWidget {
  const DashboardHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Formatters.greeting()}, ${AppConstants.mockUserName}',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Total Savings',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          Formatters.naira(kDashboardTotal),
          style: AppTextStyles.moneyHero,
        ),
      ],
    );
  }
}
