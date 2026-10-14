import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(uiSessionProvider).plans;

    // Build synthetic recent transactions based on active plans
    final transactions = <_TransactionItem>[
      const _TransactionItem(
        title: 'Emergency Fund Deposit',
        category: 'Automatic Savings',
        amount: 25000,
        date: 'Today, 10:45 AM',
        icon: Icons.shield_outlined,
        isCredit: true,
      ),
      const _TransactionItem(
        title: 'New Car Contribution',
        category: 'Target Savings',
        amount: 50000,
        date: 'Yesterday, 02:15 PM',
        icon: Icons.directions_car_outlined,
        isCredit: true,
      ),
      const _TransactionItem(
        title: 'Monthly Interest Payout',
        category: 'Interest Yield (12% p.a.)',
        amount: 3750,
        date: '12 Oct 2026',
        icon: Icons.trending_up,
        isCredit: true,
      ),
      const _TransactionItem(
        title: 'School Fees Plan Deposit',
        category: 'Education Savings',
        amount: 15000,
        date: '08 Oct 2026',
        icon: Icons.school_outlined,
        isCredit: true,
      ),
      ...plans.skip(3).map(
            (p) => _TransactionItem(
              title: '${p.name} Deposit',
              category: p.productName,
              amount: p.monthlyContribution > 0 ? p.monthlyContribution : 10000,
              date: '01 Oct 2026',
              icon: Icons.savings_outlined,
              isCredit: true,
            ),
          ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Summary Banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer,
                  ),
                  child: const Icon(Icons.receipt_long, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Savings Inflow',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.naira(93750),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.pill,
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Recent Activities',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          ...transactions.map((tx) => _buildTransactionCard(tx)),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(_TransactionItem tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.cardSubtle,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryContainer,
            child: Icon(tx.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.category} • ${tx.date}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${Formatters.naira(tx.amount)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionItem {
  final String title;
  final String category;
  final double amount;
  final String date;
  final IconData icon;
  final bool isCredit;

  const _TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.isCredit,
  });
}
