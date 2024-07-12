class Users {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String penName;
  String bio;
  String previousWorks;
  String role;
  bool? isActive;
  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.role,
    required this.penName,
    required this.bio,
    required this.previousWorks,
    this.isActive,
  });

  factory Users.fromJson(Map<String, dynamic> data) {
    return Users(
      id: data['user_id'] ?? '',
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      birthDate: DateTime.parse(data['birth_date'].toString()),
      role: data['role'] ?? '',
      bio: data["bio"] ?? '',
      penName: data['pen_name'] ?? '',
      previousWorks: data["previous_works"] ?? '',
      isActive: data["is_active"] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': name,
      'email': email,
      'birth_date': birthDate.toIso8601String(),
      'role': role,
      'bio': bio,
      'pen_name': penName,
      'previous_works': previousWorks,
    };
  }
}
