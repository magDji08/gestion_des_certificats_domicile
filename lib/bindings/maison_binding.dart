// bindings/maison_binding.dart
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../controllers/maison_controller.dart';
import '../controllers/quartier_controller.dart';

class MaisonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaisonController>(() => MaisonController());
    Get.lazyPut<QuartierController>(() => QuartierController());
    
    Get.lazyPut<DatabaseService>(() => DatabaseService());
  }


}
