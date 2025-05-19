import 'package:get/get.dart';
import 'package:certificat_management/models/user_model.dart';
import 'package:certificat_management/service/database_service.dart';

class AuthService {
  final DatabaseService _dbService = Get.find();

  /// Connexion utilisateur à partir de la table 'utilisateurs'
  Future<User?> login(String email, String password) async {
    final db = await _dbService.database;
    final users = await db.query(
      'utilisateurs',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isEmpty) return null;
    return User.fromMap(users.first);
  }

  /// Enregistrement d'un nouvel utilisateur dans la table 'utilisateurs'
  Future<void> register(User user) async {
    final db = await _dbService.database;
    await db.insert('utilisateurs', user.toMap());
  }
}