class Notification {
  int notificationId;
  int userId;
  String title;
  String descript;
  String? detail;
  String? picture;
  DateTime createdAt;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.descript,
    this.detail,
    this.picture,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notification_id'],
      userId: json['user_id'],
      title: json['title'],
      descript: json['descript'],
      detail: json['detail'],
      picture: json['picture'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'title': title,
      'descript': descript,
      'detail': detail,
      'picture': picture,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
