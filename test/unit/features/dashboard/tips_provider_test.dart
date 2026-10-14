import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/models/financial_tip.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/tips_repository.dart';
import 'package:koins_savings_app/features/dashboard/presentation/providers/tips_provider.dart';

class MockTipsRepository implements TipsRepository {
  bool shouldFail = false;
  List<FinancialTip> mockTips = const [
    FinancialTip(
      id: 'tip-1',
      title: '50/30/20 Rule',
      body: 'Allocate 50% to needs, 30% to wants, and 20% to savings.',
    ),
  ];

  @override
  Future<List<FinancialTip>> getTips() async {
    if (shouldFail) {
      throw const NetworkException('Failed to connect to network');
    }
    return mockTips;
  }
}

void main() {
  group('TipsNotifier & TipsState', () {
    late ProviderContainer container;
    late MockTipsRepository mockTipsRepository;

    setUp(() {
      mockTipsRepository = MockTipsRepository();
      container = ProviderContainer(
        overrides: [
          tipsRepositoryProvider.overrideWithValue(mockTipsRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is TipsInitial', () {
      final state = container.read(tipsNotifierProvider);
      expect(state, isA<TipsInitial>());
    });

    test('load sets TipsLoading then TipsLoaded on success', () async {
      final notifier = container.read(tipsNotifierProvider.notifier);
      final states = <TipsState>[];

      container.listen(tipsNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<TipsLoading>());
      expect(states[1], isA<TipsLoaded>());
      expect((states[1] as TipsLoaded).tips.length, 1);
      expect((states[1] as TipsLoaded).tips.first.title, '50/30/20 Rule');
    });

    test('load sets TipsError on repository failure', () async {
      mockTipsRepository.shouldFail = true;
      final notifier = container.read(tipsNotifierProvider.notifier);
      final states = <TipsState>[];

      container.listen(tipsNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<TipsLoading>());
      expect(states[1], isA<TipsError>());
      expect((states[1] as TipsError).message, 'Failed to connect to network');
    });
  });
}
