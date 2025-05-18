class User {
  final int? id;
  final String username;
  final String password;
  final String role;
  final int isActive;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
    this.isActive = 0,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        role: map['role'],
        isActive: map['is_active'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'role': role,
        'is_active': isActive,
      };
}
