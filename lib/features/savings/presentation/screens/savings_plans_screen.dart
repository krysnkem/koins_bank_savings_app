import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../widgets/common/empty_state.dart';
import '../../data/models/savings_plan.dart';
import '../providers/savings_provider.dart';

class SavingsPlansScreen extends ConsumerStatefulWidget {
  const SavingsPlansScreen({super.key});

  @override
  ConsumerState<SavingsPlansScreen> createState() => _SavingsPlansScreenState();
}

class _SavingsPlansScreenState extends ConsumerState<SavingsPlansScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(savingsNotifierProvider.notifier).load());
  }

  IconData _iconForProduct(String productId) {
    switch (productId) {
      case '1':
        return Icons.flag_outlined;
      case '2':
        return Icons.lock_outline;
      case '3':
        return Icons.school_outlined;
      case '4':
        return Icons.flight_outlined;
      default:
        return Icons.savings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsNotifierProvider);
    final uiPlans = ref.watch(uiSessionProvider).plans;
    debugPrint('BUILD SavingsPlansScreen: state=$state, uiPlans=${uiPlans.length}');

    List<SavingsPlan> plans = [];
    if (state is SavingsLoaded) {
      plans = state.plans;
    } else {
      plans = uiPlans
          .map(
            (p) => SavingsPlan(
              id: p.id,
              name: p.name,
              productId: p.productId,
              productName: p.productName,
              amount: p.amount,
              targetAmount: p.targetAmount,
              monthlyContribution: p.monthlyContribution,
              frequency: p.frequency,
              duration: p.duration,
              createdAt: DateTime.now(),
            ),
          )
          .toList();
    }

    final totalTarget = plans.fold<double>(0, (sum, p) => sum + p.targetAmount);
    final totalSaved = plans.fold<double>(
      0,
      (sum, p) => sum + (p.amount > 0 ? p.amount : p.monthlyContribution * 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Savings'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Create New Plan',
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () => context.push('/create'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(savingsNotifierProvider.notifier).load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
                  // Portfolio Summary Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.card,
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryContainer,
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Savings Portfolio',
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '${plans.length} Active ${plans.length == 1 ? "Plan" : "Plans"}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/create'),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('New Plan'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.button,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Target Goal',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Formatters.naira(totalTarget),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color: AppColors.cardBorder,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Accumulated',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Formatters.naira(totalSaved),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Plans Header Row
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
                    ...plans.map((plan) {
                      final currentVal = plan.amount > 0
                          ? plan.amount
                          : plan.monthlyContribution * 2;
                      final progress = plan.targetAmount > 0
                          ? (currentVal / plan.targetAmount).clamp(0.0, 1.0)
                          : 0.0;
                      final percent = (progress * 100).toInt();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: InkWell(
                          onTap: () =>
                              context.push('/product/${plan.productId}'),
                          borderRadius: AppRadius.card,
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSpacing.cardPadding),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: AppRadius.card,
                              border: Border.all(color: AppColors.cardBorder),
                              boxShadow: AppShadows.card,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          AppColors.primaryContainer,
                                      child: Icon(
                                        _iconForProduct(plan.productId),
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plan.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${plan.productName} • ${plan.duration}',
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Formatters.naira(plan.targetAmount),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Target',
                                          style: TextStyle(
                                            color: AppColors.textTertiary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                // Progress Bar Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Contribution: ${Formatters.naira(plan.monthlyContribution)}/${plan.frequency.toLowerCase()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '$percent% reached',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: AppRadius.pill,
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 7,
                                    backgroundColor: AppColors.primaryContainer,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
      ),
    );
  }
}
