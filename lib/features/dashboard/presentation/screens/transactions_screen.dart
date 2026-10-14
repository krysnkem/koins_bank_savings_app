import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../widgets/common/empty_state.dart';
import '../../../../widgets/common/error_state.dart';
import '../../../../widgets/common/fade_entry.dart';
import '../../data/models/transaction_item.dart';
import '../providers/transactions_provider.dart';

/// Screen displaying the user's dynamic transaction ledger loaded from the database backend.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final current = ref.read(transactionsNotifierProvider);
        if (current is! TransactionsLoaded) {
          ref.read(transactionsNotifierProvider.notifier).load();
        }
      }
    });
  }

  static IconData _resolveIcon(String iconKey) {
    switch (iconKey) {
      case 'car':
        return Icons.directions_car_outlined;
      case 'trending_up':
        return Icons.trending_up;
      case 'school':
        return Icons.school_outlined;
      case 'savings':
        return Icons.savings_outlined;
      default:
        return Icons.shield_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            ref.read(transactionsNotifierProvider.notifier).load(force: true),
        child: switch (state) {
          TransactionsInitial() || TransactionsLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          TransactionsError(:final message) => ErrorState(
              message: message,
              onRetry: () => ref
                  .read(transactionsNotifierProvider.notifier)
                  .load(force: true),
            ),
          TransactionsLoaded(:final transactions, :final totalInflow) =>
            FadeEntry(
              key: const ValueKey('transactions_loaded'),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          child: const Icon(
                            Icons.receipt_long,
                            color: AppColors.primary,
                            size: 24,
                          ),
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
                                Formatters.naira(totalInflow),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
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
                  if (transactions.isEmpty)
                    const EmptyState(
                      title: 'No transactions yet',
                      subtitle: 'Transactions will appear here as you save.',
                    )
                  else
                    for (int i = 0; i < transactions.length; i++)
                      FadeEntry.staggered(
                        index: i,
                        child: _buildTransactionCard(transactions[i]),
                      ),
                ],
              ),
            ),
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionItem tx) {
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
            child: Icon(
              _resolveIcon(tx.iconKey),
              color: AppColors.primary,
              size: 20,
            ),
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
                  '${tx.category} • ${tx.dateLabel}',
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
                '${tx.isCredit ? "+" : "-"}${Formatters.naira(tx.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: tx.isCredit ? AppColors.primary : AppColors.error,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.status,
                style: const TextStyle(
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
