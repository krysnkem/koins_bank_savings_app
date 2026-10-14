import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../savings/presentation/providers/savings_provider.dart';

/// Displays the greeting and the user's total savings summary with a number roll meter animation.
class DashboardHeaderSection extends ConsumerWidget {
  const DashboardHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsState = ref.watch(savingsNotifierProvider);
    final totalSavings = savingsState is SavingsLoaded
        ? savingsState.plans.fold<double>(0.0, (sum, p) => sum + p.amount)
        : 0.0;
    final isLoaded = savingsState is SavingsLoaded;

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
        TweenAnimationBuilder<double>(
          key: ValueKey('total_savings_${isLoaded}_$totalSavings'),
          tween: Tween<double>(
            begin: 0.0,
            end: isLoaded ? totalSavings : 0.0,
          ),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Text(
              Formatters.naira(value),
              style: AppTextStyles.moneyHero,
            );
          },
        ),
      ],
    );
  }
}
