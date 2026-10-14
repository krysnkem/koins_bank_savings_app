import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/datasources/posts_remote_data_source.dart';
import 'package:koins_savings_app/features/dashboard/data/models/dummy_post.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/posts_repository.dart';

class FakePostsRemoteDataSource implements PostsRemoteDataSource {
  FakePostsRemoteDataSource({this.shouldFail = false});

  bool shouldFail;
  List<DummyPost> mockPosts = const [
    DummyPost(
      id: 1,
      title: 'His mother had always taught him',
      body: 'His mother had always taught him not to ever think of himself as better than others.',
      tags: ['history'],
      views: 305,
    ),
  ];

  @override
  Future<List<DummyPost>> getPosts() async {
    if (shouldFail) throw const NetworkException('Posts fetch failed');
    return mockPosts;
  }
}

void main() {
  late FakePostsRemoteDataSource dataSource;
  late PostsRepository repository;

  setUp(() {
    dataSource = FakePostsRemoteDataSource();
    repository = PostsRepositoryImpl(remoteDataSource: dataSource);
  });

  group('PostsRepository.getPosts', () {
    test('returns posts from data source on success', () async {
      final posts = await repository.getPosts();

      expect(posts.length, 1);
      expect(posts.first.id, 1);
      expect(posts.first.title, 'His mother had always taught him');
    });

    test('rethrows exception when data source fails', () async {
      dataSource.shouldFail = true;

      expect(
        () => repository.getPosts(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
