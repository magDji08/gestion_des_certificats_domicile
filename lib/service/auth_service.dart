import 'package:get/get.dart';
import 'package:certificat_management/models/user_model.dart';
import 'package:certificat_management/service/database_service.dart';

class AuthService {
  final DatabaseService _dbService = Get.find();

  Future<User?> login(String email, String password) async {
    final db = await _dbService.database;
    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isEmpty) return null;
    return User.fromMap(users.first);
  }

  Future<void> register(User user) async {
    final db = await _dbService.database;
    await db.insert('users', user.toMap());
  }
}