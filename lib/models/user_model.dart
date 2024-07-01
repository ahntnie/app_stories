class Users {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String password;
  String photoURL;
  String role;
  Users(
      {required this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.password,
      required this.photoURL,
      required this.role});

  factory Users.fromJson(Map<String, dynamic> data) {
    return Users(
        id: data['user_id'] ?? '',
        name: data['username'] ?? '',
        email: data['email'] ?? '',
        birthDate: data['birth_date'] ?? 1,
        password: data['password'] ?? '',
        role: data['role'] ?? '',
        photoURL: data['photoURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'username': name,
      'email': email,
      'birth_date': birthDate.toString(),
      'password': password,
      'role': role,
    };
  }
}
