class Comment {
  int commentId;
  int? chapterId;
  String userId;
  String username;
  int? chapterNumber;
  int storyId;
  String content;
  DateTime createdAt;

  Comment(
      {required this.commentId,
      required this.userId,
      required this.chapterId,
      required this.storyId,
      required this.content,
      required this.createdAt,
      required this.username,
      required this.chapterNumber});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      userId: json['user_id'],
      storyId: json['story_id'],
      username: json['username'],
      chapterNumber: json['chapter_number'],
      content: json['content'],
      chapterId: json['chapter_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'username': username,
      'story_id': storyId,
      'chapter_number': chapterId,
      'content': content,
      'chapter_id': chapterId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
