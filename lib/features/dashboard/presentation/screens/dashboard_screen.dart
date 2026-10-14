import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../widgets/common/empty_state.dart';
import '../../../../widgets/common/error_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<({String title, String body})> _tips = [];
  bool _loadingTips = true;
  String? _tipsError;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    setState(() {
      _loadingTips = true;
      _tipsError = null;
    });
    // EXPECTATION: MockBackendService.getFinancialTips → GET dummyjson.com/posts?limit=3.
    try {
      final res = await http.get(Uri.parse('${AppConstants.baseUrl}/posts?limit=3'));
      if (res.statusCode != 200) throw Exception('tips');
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final posts = (data['posts'] as List).cast<Map<String, dynamic>>();
      if (!mounted) return;
      setState(() {
        _tips = posts
            .map((p) => (title: p['title'] as String, body: p['body'] as String))
            .toList();
        _loadingTips = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingTips = false;
        _tipsError = "Couldn't load tips. Check your connection.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(uiSessionProvider).plans.take(3).toList();
    final icons = [Icons.shield_outlined, Icons.home_outlined, Icons.school_outlined];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // EXPECTATION: navigate to Profile.
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            '${Formatters.greeting()}, ${AppConstants.mockUserName}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Total Savings', style: TextStyle(color: AppColors.textSecondary)),
          Text(
            Formatters.naira(kDashboardTotal),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.add,
                  label: 'Create Savings',
                  onTap: () {
                    // EXPECTATION: open Create Savings with no product pre-selected.
                    Navigator.of(context).pushNamed('/create');
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _QuickAction(
                  icon: Icons.savings_outlined,
                  label: 'View Products',
                  onTap: () {
                    // EXPECTATION: navigate to Savings Products.
                    Navigator.of(context).pushNamed('/products');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Recent Savings', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (plans.isEmpty)
            const EmptyState(
              title: 'No savings plans yet',
              subtitle: 'Create your first plan to get started',
            )
          else
            ...List.generate(plans.length, (i) {
              final plan = plans[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryContainer,
                      child: Icon(icons[i % icons.length], color: AppColors.primary),
                    ),
                    title: Text(plan.name),
                    subtitle: Text(plan.frequency),
                    trailing: Text(
                      Formatters.naira(plan.amount == 0 ? plan.targetAmount : plan.amount),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: AppSpacing.lg),
          Text('Financial Tips', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (_loadingTips)
            const Center(child: CircularProgressIndicator(color: AppColors.primary))
          else if (_tipsError != null)
            ErrorState(message: _tipsError!, onRetry: _loadTips)
          else
            ..._tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  color: AppColors.primaryContainer,
                  child: ListTile(
                    title: Text(tip.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(tip.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
