import '../../../savings/data/models/savings_plan.dart';
import '../../data/models/dummy_post.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final double totalSavings;
  final List<SavingsPlan> recentPlans;
  final List<DummyPost> posts;

  const DashboardLoaded({
    required this.totalSavings,
    required this.recentPlans,
    required this.posts,
  });
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}
