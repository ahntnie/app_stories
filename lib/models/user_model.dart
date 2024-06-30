class User {
  int userId;
  String username;
  String password;
  String email;
  DateTime createdAt;

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'password': password,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
