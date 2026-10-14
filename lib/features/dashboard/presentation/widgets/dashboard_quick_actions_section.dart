import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

/// Displays the quick action shortcuts on the dashboard.
class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionItem(
            icon: Icons.add,
            label: 'Create Savings',
            onTap: () => context.push('/create'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickActionItem(
            icon: Icons.savings_outlined,
            label: 'View Products',
            onTap: () => context.go('/products'),
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
