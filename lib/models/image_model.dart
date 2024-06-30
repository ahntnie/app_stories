class Image {
  int id;
  String path;
  int storyId;
  int chapterId;
  int isCoverImage;
  DateTime createdAt;
  DateTime updatedAt;

  Image({
    required this.id,
    required this.path,
    required this.storyId,
    required this.chapterId,
    required this.isCoverImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      path: json['path'],
      storyId: json['story_id'],
      chapterId: json['chapter_id'],
      isCoverImage: json['is_cover_image'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'story_id': storyId,
      'chapter_id': chapterId,
      'is_cover_image': isCoverImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
