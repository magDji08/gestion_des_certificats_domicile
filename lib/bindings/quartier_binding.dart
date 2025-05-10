import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../controllers/quartier_controller.dart';

class QuartierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuartierController>(() => QuartierController());
    Get.lazyPut<DatabaseService>(() => DatabaseService());
  }
}
