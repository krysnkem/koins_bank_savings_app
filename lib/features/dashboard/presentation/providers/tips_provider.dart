import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../services/backend_provider.dart';
import '../../data/datasources/tips_remote_data_source.dart';
import '../../data/models/financial_tip.dart';
import '../../data/repositories/dashboard_repository.dart';

sealed class TipsState {
  const TipsState();
}

class TipsInitial extends TipsState {
  const TipsInitial();
}

class TipsLoading extends TipsState {
  const TipsLoading();
}

class TipsLoaded extends TipsState {
  final List<FinancialTip> tips;
  const TipsLoaded(this.tips);
}

class TipsError extends TipsState {
  final String message;
  const TipsError(this.message);
}

final tipsRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    tipsDataSource: TipsRemoteDataSourceImpl(ref.watch(backendServiceProvider)),
  );
});

final tipsNotifierProvider =
    NotifierProvider.autoDispose<TipsNotifier, TipsState>(TipsNotifier.new);

class TipsNotifier extends AutoDisposeNotifier<TipsState> {
  late final DashboardRepository _dashboard;

  @override
  TipsState build() {
    _dashboard = ref.watch(tipsRepositoryProvider);
    return const TipsInitial();
  }

  Future<void> load() async {
    state = const TipsLoading();
    try {
      final tips = await _dashboard.getTips();
      state = TipsLoaded(tips);
    } catch (e) {
      if (e is AppException) {
        state = TipsError(e.message);
      } else {
        state = TipsError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }
}
