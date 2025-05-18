// bindings/certificat_binding.dart
import 'package:certificat_management/controllers/auth_controller.dart';
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {

    // Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController());

    Get.lazyPut<DatabaseService>(() => DatabaseService());
  }
}