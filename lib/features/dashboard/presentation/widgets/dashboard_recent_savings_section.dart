import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../widgets/common/empty_state.dart';
import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/presentation/providers/savings_provider.dart';

/// Displays the user's recent savings plans on the dashboard.
class DashboardRecentSavingsSection extends ConsumerWidget {
  const DashboardRecentSavingsSection({super.key});

  static const _planIcons = [
    Icons.shield_outlined,
    Icons.home_outlined,
    Icons.school_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsState = ref.watch(savingsNotifierProvider);
    final plans = savingsState is SavingsLoaded
        ? savingsState.plans.take(3).toList()
        : <SavingsPlan>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Savings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
            InkWell(
              onTap: () => context.go('/my-savings'),
              borderRadius: AppRadius.badge,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (plans.isEmpty)
          const EmptyState(
            title: 'No savings plans yet',
            subtitle: 'Create your first plan to get started',
          )
        else
          for (int i = 0; i < plans.length; i++)
            _RecentSavingsCard(
              plan: plans[i],
              icon: _planIcons[i % _planIcons.length],
            ),
      ],
    );
  }
}

class _RecentSavingsCard extends StatelessWidget {
  final SavingsPlan plan;
  final IconData icon;

  const _RecentSavingsCard({
    required this.plan,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.card,
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () => context.push('/product/${plan.productId}'),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(icon, color: AppColors.primary),
            ),
            title: Text(
              plan.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              plan.frequency,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.naira(plan.amount == 0 ? plan.targetAmount : plan.amount),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
