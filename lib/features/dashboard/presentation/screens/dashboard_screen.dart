import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../widgets/dashboard_header_section.dart';
import '../widgets/dashboard_quick_actions_section.dart';
import '../widgets/dashboard_recent_savings_section.dart';
import '../widgets/dashboard_tips_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      body: ListView(
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
    );
  }
}
