import 'package:get/get.dart';
import 'package:certificat_management/pages/home_page.dart';
import 'package:certificat_management/pages/quartier/list_page.dart';

class AppPages {
  final routes = [
    GetPage(
      name: '/',
      page: () => HomePage(),
    ),
    GetPage(
      name: '/quartiers',
      page: () => QuartierListPage(),
    ),
    // Ajoutez vos autres routes ici
  ];
}