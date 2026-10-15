import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/common/app_shimmer.dart';
import '../../../../widgets/common/error_state.dart';
import '../../../../widgets/common/fade_entry.dart';
import '../../data/models/dummy_post.dart';
import '../providers/posts_provider.dart';

/// Displays the "Posts from Dummy JSON" section, handling initial, loading, error, and loaded states independently.
class DashboardPostsSection extends ConsumerWidget {
  const DashboardPostsSection({super.key});

  static const _postIcons = [
    Icons.article_outlined,
    Icons.dynamic_feed_outlined,
    Icons.public_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Posts from Dummy JSON',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'REST API',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (postsState) {
            PostsInitial() || PostsLoading() => const Column(
                key: ValueKey('posts_loading'),
                children: [
                  PostCardShimmer(),
                  PostCardShimmer(),
                  PostCardShimmer(),
                ],
              ),
            PostsError(:final message) => ErrorState(
                key: const ValueKey('posts_error'),
                message: message,
                onRetry: () => ref.read(postsNotifierProvider.notifier).load(),
              ),
            PostsLoaded(:final posts) => FadeEntry(
                key: const ValueKey('posts_loaded'),
                child: Column(
                  children: [
                    for (int i = 0; i < posts.length; i++)
                      FadeEntry.staggered(
                        index: i,
                        child: _PostCard(
                          post: posts[i],
                          icon: _postIcons[i % _postIcons.length],
                        ),
                      ),
                  ],
                ),
              ),
          },
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final DummyPost post;
  final IconData icon;

  const _PostCard({
    required this.post,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.card,
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            title: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),
                if (post.tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final tag in post.tags.take(3))
                        Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.more_vert, size: 20, color: AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}
