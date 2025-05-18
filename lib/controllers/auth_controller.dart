// import 'package:certificat_management/service/auth_service.dart';
// import 'package:get/get.dart';
// import 'package:certificat_management/models/user_model.dart';


import 'package:get/get.dart';
import '../models/user.dart';
import '../service/database_service.dart';

class AuthController extends GetxController {
  late final DatabaseService dbService;
  final Rxn<User> currentUser = Rxn<User>();

  @override
  void onInit() {
    dbService = Get.find();
    // dbService = Get.find<DatabaseService>();

    super.onInit();
  }

  Future<bool> login(String username, String password) async {
    final db = await dbService.database;
    final result = await db.query(
      'utilisateurs',
      where: 'username = ? AND password = ? AND is_active = 1',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      currentUser.value = User.fromMap(result.first);
      return true;
    }
    return false;
  }

  Future<void> register(String username, String password, String role) async {
    final db = await dbService.database;
    await db.insert('utilisateurs', {
      'username': username,
      'password': password,
      'role': role,
      'is_active': role == 'citoyen' ? 1 : 0, // Citoyen activé automatiquement
    });
  }

  Future<void> activateUser(int userId) async {
    final db = await dbService.database;
    await db.update('utilisateurs', {'is_active': 1}, where: 'id = ?', whereArgs: [userId]);
  }

  void logout() {
    currentUser.value = null;
  }
}

































// class AuthController extends GetxController {
//   final AuthService _authService = Get.find();
//   final Rx<User?> currentUser = Rx<User?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   Future<bool> login(String email, String password) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final user = await _authService.login(email, password);
//       if (user == null) {
//         errorMessage.value = 'Email ou mot de passe incorrect';
//         return false;
//       }

//       currentUser.value = user;
//       return true;
//     } catch (e) {
//       errorMessage.value = 'Erreur de connexion: ${e.toString()}';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> register(User user) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       await _authService.register(user);
//       return true;
//     } catch (e) {
//       errorMessage.value = 'Erreur d\'inscription: ${e.toString()}';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void logout() {
//     currentUser.value = null;
//     Get.offAllNamed('/login');
//   }

//   // Vérifie l'état d'authentification au démarrage
//   Future<void> checkAuthStatus() async {
//     isLoading.value = true;
//     // Implémentez votre logique de vérification de session ici
//     // Par exemple, vérifier un token en local storage
//     isLoading.value = false;
//   }
// }