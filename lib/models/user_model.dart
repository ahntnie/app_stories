class Users {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String password;

  String role;
  Users(
      {required this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.password,
      required this.role});

  factory Users.fromJson(Map<String, dynamic> data) {
    return Users(
      id: data['user_id'] ?? '',
      name: data['username'] ?? '',
      email: data['email'] ?? '',
      birthDate: DateTime.parse(data['birth_date'].toString()),
      password: data['password'] ?? '',
      role: data['role'] ?? '',
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
    };
  }
}
