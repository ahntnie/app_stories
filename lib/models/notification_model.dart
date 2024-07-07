import 'package:app_stories/models/chapter_model.dart';
import 'package:app_stories/models/story_model.dart';

class Notification {
  int id;
  String userId;
  String title;
  String message;
  String type;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;
  Story story;
  Chapter chapter;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.story,
    required this.chapter,
  });

  // Phương thức từ JSON để chuyển đổi JSON thành một đối tượng Notification
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'] == 1, // Chuyển đổi từ int sang bool
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      story: Story.fromJson(json["story"]),
      chapter: Chapter.fromJson(json["chapter"]),
    );
  }

  // Phương thức để chuyển đổi đối tượng Notification thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead ? 1 : 0, // Chuyển đổi từ bool sang int
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
