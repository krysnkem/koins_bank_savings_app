import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/session/ui_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
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
  int _currentIndex = 0;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Savings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/products'),
                borderRadius: AppRadius.badge,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                    title: Text(
                      plan.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(plan.frequency),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Formatters.naira(plan.amount == 0 ? plan.targetAmount : plan.amount),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Financial Tips',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_loadingTips)
            const Center(child: CircularProgressIndicator(color: AppColors.primary))
          else if (_tipsError != null)
            ErrorState(message: _tipsError!, onRetry: _loadTips)
          else ...[
            () {
              const tipIcons = [
                Icons.lightbulb_outline,
                Icons.track_changes,
                Icons.savings_outlined,
              ];
              return Column(
                children: [
                  for (int i = 0; i < _tips.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryContainer,
                            child: Icon(
                              tipIcons[i % tipIcons.length],
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            _tips[i].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _tips[i].body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.more_vert, size: 20, color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                ],
              );
            }(),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.of(context).pushNamed('/products');
          } else if (index == 3) {
            Navigator.of(context).pushNamed('/profile');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
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
        borderRadius: AppRadius.card,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
