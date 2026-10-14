import '../../data/models/dummy_post.dart';

sealed class PostsState {
  const PostsState();
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<DummyPost> posts;
  const PostsLoaded(this.posts);
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);
}
