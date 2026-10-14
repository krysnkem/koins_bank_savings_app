import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

export 'dashboard_state.dart';
export 'tips_provider.dart';

final dashboardNotifierProvider =
    NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AutoDisposeNotifier<DashboardState> {
  late final DashboardRepository _dashboardRepository;

  @override
  DashboardState build() {
    _dashboardRepository = ref.watch(dashboardRepositoryProvider);
    return const DashboardInitial();
  }

  Future<void> load() async {
    state = const DashboardLoading();
    try {
      final data = await _dashboardRepository.getDashboardData();
      state = DashboardLoaded(
        totalSavings: data.totalSavings,
        recentPlans: data.recentPlans,
        tips: data.tips,
      );
    } catch (e) {
      if (e is AppException) {
        state = DashboardError(e.message);
      } else {
        state = DashboardError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }
}
