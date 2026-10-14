import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/backend_provider.dart';
import '../datasources/posts_remote_data_source.dart';
import '../models/dummy_post.dart';

abstract class PostsRepository {
  Future<List<DummyPost>> getPosts();
}

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl({
    required PostsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<List<DummyPost>> getPosts() {
    return _remoteDataSource.getPosts();
  }
}

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  return PostsRepositoryImpl(
    remoteDataSource: PostsRemoteDataSourceImpl(ref.watch(backendServiceProvider)),
  );
});
