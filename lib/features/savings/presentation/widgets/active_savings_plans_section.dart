import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/common/empty_state.dart';
import '../../data/models/savings_plan.dart';
import 'savings_plan_card.dart';

/// Section listing active savings plans or an empty state prompt.
class ActiveSavingsPlansSection extends StatelessWidget {
  final List<SavingsPlan> plans;

  const ActiveSavingsPlansSection({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Savings Plans',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                '${plans.length} Goals',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (plans.isEmpty)
          EmptyState(
            title: 'No savings plans yet',
            subtitle:
                'Create your first savings goal and watch your wealth grow.',
            action: ElevatedButton(
              onPressed: () => context.push('/create'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.button,
                ),
              ),
              child: const Text('Create Plan'),
            ),
          )
        else
          for (final plan in plans) SavingsPlanCard(plan: plan),
      ],
    );
  }
}
