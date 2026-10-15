import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/posts_repository.dart';
import 'posts_state.dart';

export 'posts_state.dart';

final postsNotifierProvider =
    NotifierProvider.autoDispose<PostsNotifier, PostsState>(PostsNotifier.new);

class PostsNotifier extends AutoDisposeNotifier<PostsState> {
  late final PostsRepository _postsRepository;

  @override
  PostsState build() {
    _postsRepository = ref.watch(postsRepositoryProvider);
    return const PostsInitial();
  }

  Future<void> load() async {
    state = const PostsLoading();
    try {
      final posts = await _postsRepository.getPosts();
      state = PostsLoaded(posts);
    } catch (e) {
      state = PostsError(ErrorHandler.getUserMessage(e));
    }
  }
}
