// bindings/certificat_binding.dart
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../controllers/certificat_controller.dart';
import '../controllers/personne_controlller.dart';

class CertificatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CertificatController());
    if (!Get.isRegistered<PersonneController>()) {
      Get.lazyPut(() => PersonneController());
    }


    Get.lazyPut<DatabaseService>(() => DatabaseService());
  }
}