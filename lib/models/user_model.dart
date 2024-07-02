class Users {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String role;
  Users(
      {required this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.role});

  factory Users.fromJson(Map<String, dynamic> data) {
    return Users(
      id: data['user_id'] ?? '',
      name: data['username'] ?? '',
      birthDate: DateTime.parse(data['birth_date']),
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': name,
      'email': email,
      'birth_date': birthDate.toString(),
      'role': role,
    };
  }
}
