import '../../data/models/transaction_item.dart';

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
