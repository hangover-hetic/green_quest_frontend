List<Post> postTestFromJson(List<Map<String, dynamic>> json) =>
    List<Post>.from(json.map(Post.fromJson));

class Post {
  final String title;
  final String body;
  final int id;
  final int userId;

  Post({required this.title, required this.body, required this.id, required this.userId});

  factory Post.fromJson(Map<String, dynamic> json) {
    print(json);
    return Post(
      id: json['id'] as int,
      title: (json['title'] ?? "") as String,
      body: (json['body'] ?? "") as String,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }
}
