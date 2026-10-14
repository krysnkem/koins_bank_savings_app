import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header_section.dart';
import '../widgets/dashboard_quick_actions_section.dart';
import '../widgets/dashboard_recent_savings_section.dart';
import '../widgets/dashboard_tips_section.dart';

/// Financial dashboard screen displaying greeting, balance, quick actions, recent plans, and tips.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Delay loading data until the screen is mounted and visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(dashboardNotifierProvider.notifier).load();
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
        onRefresh: () => ref.read(dashboardNotifierProvider.notifier).load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: const [
            DashboardHeaderSection(),
            SizedBox(height: AppSpacing.lg),
            DashboardQuickActionsSection(),
            SizedBox(height: AppSpacing.xl),
            DashboardRecentSavingsSection(),
            SizedBox(height: AppSpacing.lg),
            DashboardTipsSection(),
          ],
        ),
      ),
    );
  }
}
