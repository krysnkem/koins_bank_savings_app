import '../datasources/transactions_remote_data_source.dart';
import '../models/transaction_item.dart';

abstract class TransactionsRepository {
  Future<List<TransactionItem>> getTransactions();
}

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl({
    required TransactionsRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final TransactionsRemoteDataSource _remote;

  @override
  Future<List<TransactionItem>> getTransactions() => _remote.getTransactions();
}
