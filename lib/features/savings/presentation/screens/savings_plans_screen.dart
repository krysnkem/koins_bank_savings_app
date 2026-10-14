import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/savings_plan.dart';
import '../providers/savings_provider.dart';
import '../widgets/active_savings_plans_section.dart';
import '../widgets/savings_portfolio_section.dart';

/// Screen displaying the user's savings plans portfolio and list of active goals.
class SavingsPlansScreen extends ConsumerStatefulWidget {
  const SavingsPlansScreen({super.key});

  @override
  ConsumerState<SavingsPlansScreen> createState() => _SavingsPlansScreenState();
}

class _SavingsPlansScreenState extends ConsumerState<SavingsPlansScreen> {
  @override
  void initState() {
    super.initState();
    // Delay loading data until the screen is mounted and visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(savingsNotifierProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsNotifierProvider);
    final plans = state is SavingsLoaded ? state.plans : const <SavingsPlan>[];

    final totalTarget = plans.fold<double>(0, (sum, p) => sum + p.targetAmount);
    final totalSaved = plans.fold<double>(0, (sum, p) => sum + p.amount);

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: state is SavingsLoading
              ? const Center(
                  key: ValueKey('savings_loading'),
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : AnimatedOpacity(
                  key: const ValueKey('savings_loaded'),
                  opacity: state is SavingsLoaded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  child: ListView(
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
        ),
      ),
    );
  }
}
