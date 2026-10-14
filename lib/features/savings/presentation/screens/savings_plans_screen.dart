import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/savings_plan.dart';
import '../providers/savings_provider.dart';
import '../widgets/active_savings_plans_section.dart';
import '../widgets/savings_portfolio_section.dart';

/// Screen displaying the user's savings plans portfolio and list of active goals.
class SavingsPlansScreen extends ConsumerWidget {
  const SavingsPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savingsNotifierProvider);
    final uiPlans = ref.watch(uiSessionProvider).plans;

    final plans = state is SavingsLoaded
        ? state.plans
        : uiPlans
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
        child: state is SavingsLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  SavingsPortfolioSection(
                    planCount: plans.length,
                    totalTarget: totalTarget,
                    totalSaved: totalSaved,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ActiveSavingsPlansSection(plans: plans),
                ],
              ),
      ),
    );
  }
}
