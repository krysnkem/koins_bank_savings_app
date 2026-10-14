import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../savings/data/models/savings_plan.dart';
import '../../../savings/data/repositories/savings_repository.dart';
import '../models/dummy_post.dart';
import 'posts_repository.dart';

class DashboardData {
  final double totalSavings;
  final List<SavingsPlan> recentPlans;
  final List<DummyPost> posts;

  const DashboardData({
    required this.totalSavings,
    required this.recentPlans,
    required this.posts,
  });
}

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData();
}

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required SavingsRepository savingsRepository,
    required PostsRepository postsRepository,
  })  : _savingsRepository = savingsRepository,
        _postsRepository = postsRepository;

  final SavingsRepository _savingsRepository;
  final PostsRepository _postsRepository;

  @override
  Future<DashboardData> getDashboardData() async {
    final results = await Future.wait([
      _savingsRepository.getPlans(),
      _postsRepository.getPosts().catchError((_) => <DummyPost>[]),
    ]);

    final allPlans = results[0] as List<SavingsPlan>;
    final posts = results[1] as List<DummyPost>;
    final totalSavings = allPlans.fold<double>(
      0.0,
      (sum, p) => sum + p.amount,
    );

    return DashboardData(
      totalSavings: totalSavings,
      recentPlans: allPlans.take(3).toList(),
      posts: posts,
    );
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    savingsRepository: ref.watch(savingsRepositoryProvider),
    postsRepository: ref.watch(postsRepositoryProvider),
  );
});
