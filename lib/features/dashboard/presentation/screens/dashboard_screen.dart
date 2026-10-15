import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../savings/presentation/providers/savings_provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/dashboard_header_section.dart';
import '../widgets/dashboard_posts_section.dart';
import '../widgets/dashboard_quick_actions_section.dart';
import '../widgets/dashboard_recent_savings_section.dart';

/// Financial dashboard screen displaying greeting, balance, quick actions, recent plans, and live posts from DummyJSON.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load savings and DummyJSON posts independently once the dashboard mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(savingsNotifierProvider.notifier).load();
        ref.read(postsNotifierProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.wait([
            ref.read(savingsNotifierProvider.notifier).load(force: true),
            ref.read(postsNotifierProvider.notifier).load(),
          ]);
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeaderSection(),
              SizedBox(height: AppSpacing.lg),
              DashboardQuickActionsSection(),
              SizedBox(height: AppSpacing.xl),
              DashboardRecentSavingsSection(),
              SizedBox(height: AppSpacing.lg),
              DashboardPostsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
