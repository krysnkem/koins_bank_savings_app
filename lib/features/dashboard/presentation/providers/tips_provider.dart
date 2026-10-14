import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'tips_state.dart';

export 'tips_state.dart';

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
