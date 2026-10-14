import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/datasources/tips_remote_data_source.dart';
import 'package:koins_savings_app/features/dashboard/data/models/financial_tip.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/tips_repository.dart';

class FakeTipsRemoteDataSource implements TipsRemoteDataSource {
  FakeTipsRemoteDataSource({this.shouldFail = false});

  bool shouldFail;
  List<FinancialTip> mockTips = const [
    FinancialTip(
      id: 'tip-1',
      title: 'Emergency Fund',
      body: 'Keep 3-6 months of expenses in an emergency fund.',
    ),
  ];

  @override
  Future<List<FinancialTip>> getFinancialTips() async {
    if (shouldFail) throw const NetworkException('Tips fetch failed');
    return mockTips;
  }
}

void main() {
  late FakeTipsRemoteDataSource dataSource;
  late TipsRepository repository;

  setUp(() {
    dataSource = FakeTipsRemoteDataSource();
    repository = TipsRepositoryImpl(tipsDataSource: dataSource);
  });

  group('TipsRepository.getTips', () {
    test('returns tips from data source on success', () async {
      final tips = await repository.getTips();

      expect(tips.length, 1);
      expect(tips.first.id, 'tip-1');
      expect(tips.first.title, 'Emergency Fund');
    });

    test('rethrows exception when data source fails', () async {
      dataSource.shouldFail = true;

      expect(
        () => repository.getTips(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
