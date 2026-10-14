import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/dashboard/data/models/dummy_post.dart';
import 'package:koins_savings_app/features/dashboard/data/repositories/posts_repository.dart';
import 'package:koins_savings_app/features/dashboard/presentation/providers/posts_provider.dart';

class MockPostsRepository implements PostsRepository {
  bool shouldFail = false;
  List<DummyPost> mockPosts = const [
    DummyPost(
      id: 1,
      title: 'His mother had always taught him',
      body: 'His mother had always taught him not to ever think of himself as better than others.',
      tags: ['history', 'american'],
      views: 305,
    ),
  ];

  @override
  Future<List<DummyPost>> getPosts() async {
    if (shouldFail) {
      throw const NetworkException('Failed to connect to network');
    }
    return mockPosts;
  }
}

void main() {
  group('PostsNotifier & PostsState', () {
    late ProviderContainer container;
    late MockPostsRepository mockPostsRepository;

    setUp(() {
      mockPostsRepository = MockPostsRepository();
      container = ProviderContainer(
        overrides: [
          postsRepositoryProvider.overrideWithValue(mockPostsRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is PostsInitial', () {
      final state = container.read(postsNotifierProvider);
      expect(state, isA<PostsInitial>());
    });

    test('load sets PostsLoading then PostsLoaded on success', () async {
      final notifier = container.read(postsNotifierProvider.notifier);
      final states = <PostsState>[];

      container.listen(postsNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<PostsLoading>());
      expect(states[1], isA<PostsLoaded>());
      expect((states[1] as PostsLoaded).posts.length, 1);
      expect((states[1] as PostsLoaded).posts.first.title, 'His mother had always taught him');
    });

    test('load sets PostsError on repository failure', () async {
      mockPostsRepository.shouldFail = true;
      final notifier = container.read(postsNotifierProvider.notifier);
      final states = <PostsState>[];

      container.listen(postsNotifierProvider, (_, next) {
        states.add(next);
      });

      await notifier.load();

      expect(states.length, 2);
      expect(states[0], isA<PostsLoading>());
      expect(states[1], isA<PostsError>());
      expect((states[1] as PostsError).message, 'Failed to connect to network');
    });
  });
}
