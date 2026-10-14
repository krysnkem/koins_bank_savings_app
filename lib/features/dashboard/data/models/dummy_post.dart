class DummyPost {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;

  const DummyPost({
    required this.id,
    required this.title,
    required this.body,
    this.tags = const [],
    this.views = 0,
  });

  factory DummyPost.fromJson(Map<String, dynamic> json) {
    return DummyPost(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ??
          const [],
      views: json['views'] is int ? json['views'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'tags': tags,
        'views': views,
      };
}
