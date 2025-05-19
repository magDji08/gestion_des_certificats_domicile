import 'package:get/get.dart';
import '../models/user.dart';
import '../service/database_service.dart';

class AuthController extends GetxController {
  late final DatabaseService dbService;
  final Rxn<User> currentUser = Rxn<User>();

  @override
  void onInit() {
    dbService = Get.find();
    super.onInit();
  }

  

  /// Connexion utilisateur avec validation d'activation
  Future<bool> login(String email, String password) async {
    final db = await dbService.database;
    final result = await db.query(
      'utilisateurs',
      where: 'email = ? AND password = ? AND is_active = 1',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      currentUser.value = User.fromMap(result.first);
      return true;
    }
    return false;
  }

  /// Enregistrement d'un nouvel utilisateur (citoyen activé automatiquement)
  Future<void> register(String username, String password, String role, String email) async {
    final db = await dbService.database;
    await db.insert('utilisateurs', {
      'username': username,
      'password': password,
      'role': role,
      'email': email,
      'is_active': role == 'citoyen' ? 1 : 0,
    });
  }


  /// Activation d'un utilisateur (par l'admin ou agent)
  Future<void> activateUser(int userId) async {
    final db = await dbService.database;
    await db.update('utilisateurs', {'is_active': 1}, where: 'id = ?', whereArgs: [userId]);
  }

  /// Déconnexion utilisateur courant
  void logout() {
    currentUser.value = null;
  }
}
