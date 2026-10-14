import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/error_state.dart';
import '../../data/models/financial_tip.dart';
import '../providers/tips_provider.dart';

/// Displays the financial tips section, handling initial, loading, error, and loaded states independently.
class DashboardTipsSection extends ConsumerWidget {
  const DashboardTipsSection({super.key});

  static const _tipIcons = [
    Icons.lightbulb_outline,
    Icons.track_changes,
    Icons.savings_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsState = ref.watch(tipsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Tips',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (tipsState) {
            TipsInitial() || TipsLoading() => const Center(
                key: ValueKey('tips_loading'),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            TipsError(:final message) => ErrorState(
                key: const ValueKey('tips_error'),
                message: message,
                onRetry: () => ref.read(tipsNotifierProvider.notifier).load(),
              ),
            TipsLoaded(:final tips) => AnimatedOpacity(
                key: const ValueKey('tips_loaded'),
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    for (int i = 0; i < tips.length; i++)
                      _TipCard(
                        tip: tips[i],
                        icon: _tipIcons[i % _tipIcons.length],
                      ),
                  ],
                ),
              ),
          },
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final FinancialTip tip;
  final IconData icon;

  const _TipCard({
    required this.tip,
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
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            title: Text(
              tip.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                tip.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
            trailing: const Icon(Icons.more_vert, size: 20, color: AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}
