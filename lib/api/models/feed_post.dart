import 'package:green_quest_frontend/api/models/user.dart';

class FeedPost {
  FeedPost({
    required this.title,
    required this.content,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.coverUrl,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coverUrl: (json['coverUrl'] ?? '') as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
    );
  }

  final String title;
  final String content;
  final String? coverUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User author;
  final int id;
}
