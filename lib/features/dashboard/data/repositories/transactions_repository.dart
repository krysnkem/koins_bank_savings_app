import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/backend_provider.dart';
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

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(
    remoteDataSource: TransactionsRemoteDataSourceImpl(
      ref.watch(backendServiceProvider),
    ),
  );
});
