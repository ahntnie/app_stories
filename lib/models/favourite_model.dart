class Favorite {
  int favoriteId;
  String userId;
  int? storyId;
  DateTime createdAt;

  Favorite({
    required this.favoriteId,
    required this.userId,
    required this.storyId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteId: json['favorite_id'],
      userId: json['user_id'],
      storyId: json['story_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorite_id': favoriteId,
      'user_id': userId,
      'story_id': storyId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
