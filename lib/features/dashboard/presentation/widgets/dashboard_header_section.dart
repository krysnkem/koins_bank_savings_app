import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/dashboard_provider.dart';

/// Displays the greeting and the user's total savings summary loaded from disk via DashboardNotifier.
class DashboardHeaderSection extends ConsumerWidget {
  const DashboardHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);

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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: state is DashboardLoaded
              ? Text(
                  Formatters.naira(state.totalSavings),
                  key: const ValueKey('loaded_total'),
                  style: AppTextStyles.moneyHero,
                )
              : Container(
                  key: const ValueKey('loading_total'),
                  height: 38,
                  width: 140,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder.withValues(alpha: 0.4),
                    borderRadius: AppRadius.input,
                  ),
                ),
        ),
      ],
    );
  }
}
