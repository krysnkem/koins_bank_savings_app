import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/transactions_repository.dart';
import 'transactions_state.dart';

export 'transactions_state.dart';

final transactionsNotifierProvider =
    NotifierProvider.autoDispose<TransactionsNotifier, TransactionsState>(
  TransactionsNotifier.new,
);

class TransactionsNotifier extends AutoDisposeNotifier<TransactionsState> {
  late final TransactionsRepository _repository;

  @override
  TransactionsState build() {
    _repository = ref.watch(transactionsRepositoryProvider);
    return const TransactionsInitial();
  }

  Future<void> load({bool force = false}) async {
    if (!force && state is TransactionsLoaded) {
      return;
    }
    state = const TransactionsLoading();
    try {
      final items = await _repository.getTransactions();
      final totalInflow = items
          .where((t) => t.isCredit)
          .fold<double>(0.0, (sum, t) => sum + t.amount);
      state = TransactionsLoaded(
        transactions: items,
        totalInflow: totalInflow,
      );
    } catch (e) {
      if (e is AppException) {
        state = TransactionsError(e.message);
      } else {
        state = TransactionsError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }
}
