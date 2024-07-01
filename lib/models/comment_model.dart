class Comment {
  int commentId;
  int userId;
  int storyId;
  String content;
  DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.storyId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      userId: json['user_id'],
      storyId: json['story_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'story_id': storyId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
