import '../../../../services/backend_service.dart';
import '../models/dummy_post.dart';

abstract class PostsRemoteDataSource {
  Future<List<DummyPost>> getPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl(this._backend);

  final BackendService _backend;

  @override
  Future<List<DummyPost>> getPosts() {
    return _backend.getPosts();
  }
}
