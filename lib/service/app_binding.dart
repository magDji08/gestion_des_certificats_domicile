import 'package:certificat_management/controllers/auth_controller.dart';
import 'package:certificat_management/controllers/certificat_controller.dart';
import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:certificat_management/service/database_service.dart';
import 'package:get/get.dart';
import '../controllers/quartier_controller.dart';
import '../controllers/maison_controller.dart';
// import '../controllers/proprietaire_controller.dart';
// import '../controllers/habitant_controller.dart';
// import '../controllers/certificat_controller.dart';
// import '../services/database_service.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Initialisation du service de base de données (singleton)
    _initDatabaseService();

    // Initialisation des contrôleurs
    _initQuartierController();
    _initMaisonController();
    _initPersonneController();
    // _initHabitantController();
    _initCertificatController();
    _initAuthController();
  }

  // Méthodes d'initialisation séparées pour plus de clarté

  void _initDatabaseService() {
    // Get.lazyPut<DatabaseService>(
    //   () => DatabaseService(),
          Get.lazyPut<DatabaseService>(() => DatabaseService(), fenix: true);
      // tag: 'database', // Tag optionnel pour identification
      // fenix: true, // Recrée l'instance si elle a été supprimée
    
  }

  void _initQuartierController() {
    Get.lazyPut<QuartierController>(
      () => QuartierController(),
      fenix: true,
    );
  }

  void _initAuthController() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );
  }


  void _initMaisonController() {
    Get.lazyPut<MaisonController>(
      () => MaisonController(),
      fenix: true,
    );
  }

  void _initPersonneController() {
    Get.lazyPut<PersonneController>(
      () => PersonneController(),
      fenix: true,
    );
  }

  // void _initHabitantController() {
  //   Get.lazyPut<HabitantController>(
  //     () => HabitantController(),
  //     fenix: true,
  //   );
  // }

  void _initCertificatController() {
    Get.lazyPut<CertificatController>(
      () => CertificatController(),
      fenix: true,
    );
  }
}