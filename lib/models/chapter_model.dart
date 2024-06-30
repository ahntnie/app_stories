import 'package:app_stories/constants/api.dart';
class Chapter {
  int chapterId;
  int storyId;
  String title;
  String content;
  int chapterNumber;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;

  Chapter({
    required this.chapterId,
    required this.storyId,
    required this.title,
    required this.content,
    required this.chapterNumber,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapter_id'],
      storyId: json['story_id'],
      title: json['title'],
      content: json['content'],
      chapterNumber: json['chapter_number'],
      images:
          List<String>.from(json['images'].map((x) => "${Api.hostImage}$x")),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_id': chapterId,
      'story_id': storyId,
      'title': title,
      'content': content,
      'chapter_number': chapterNumber,
      'images': List<dynamic>.from(images.map((x) => x)),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
