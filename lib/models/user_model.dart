class Users {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String password;
  String penName;
  String bio;
  String previousWorks;
  String role;
  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.password,
    required this.role,
    required this.penName,
    required this.bio,
    required this.previousWorks,
  });

  factory Users.fromJson(Map<String, dynamic> data) {
    return Users(
      id: data['user_id'] ?? '',
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      birthDate: DateTime.parse(data['birth_date'].toString()),
      password: data['password'] ?? '',
      role: data['role'] ?? '',
      bio: data["bio"] ?? '',
      penName: data['pen_name'] ?? '',
      previousWorks: data["previous_works"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': name,
      'email': email,
      'birth_date': birthDate.toIso8601String(),
      'password': password,
      'role': role,
      'bio': bio,
      'pen_name': penName,
      'previous_works': previousWorks,
    };
  }
}
