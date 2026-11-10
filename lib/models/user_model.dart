class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? token;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'Administrator',
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'usr_1',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? 'Admin User',
      role: json['role'] as String? ?? 'Administrator',
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'token': token,
    };
  }
}

