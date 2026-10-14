import '../../../../services/backend_service.dart';
import '../models/transaction_item.dart';

abstract class TransactionsRemoteDataSource {
  Future<List<TransactionItem>> getTransactions();
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  TransactionsRemoteDataSourceImpl(this._backend);
  final BackendService _backend;

  @override
  Future<List<TransactionItem>> getTransactions() => _backend.getTransactions();
}
