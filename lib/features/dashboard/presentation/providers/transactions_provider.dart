import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../services/backend_provider.dart';
import '../../data/datasources/transactions_remote_data_source.dart';
import '../../data/models/transaction_item.dart';
import '../../data/repositories/transactions_repository.dart';

sealed class TransactionsState {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionItem> transactions;
  final double totalInflow;

  const TransactionsLoaded({
    required this.transactions,
    required this.totalInflow,
  });
}

class TransactionsError extends TransactionsState {
  final String message;
  const TransactionsError(this.message);
}

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(
    remoteDataSource: TransactionsRemoteDataSourceImpl(
      ref.watch(backendServiceProvider),
    ),
  );
});

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
