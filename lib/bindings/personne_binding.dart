// bindings/personne_binding.dart
import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../controllers/maison_controller.dart';

class PersonneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonneController());
    if (!Get.isRegistered<MaisonController>()) {
      Get.lazyPut(() => MaisonController());
    }
    Get.lazyPut<DatabaseService>(() => DatabaseService());

  }
}