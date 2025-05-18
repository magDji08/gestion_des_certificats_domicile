import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:certificat_management/controllers/auth_controller.dart';
import 'package:certificat_management/pages/auth/login_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    if (authController.currentUser.value != null) {
      return null; // Autorise l'accès
    }
    
    // Redirection vers LoginPage
    Get.offAll(() => LoginPage()); // Force la navigation vers le login
    return RouteSettings(name: '/login'); // Retourne quand même un RouteSettings
  }
}

// class AuthMiddleware extends GetMiddleware {
//   @override
//   Future<RouteDecoder?> redirect(RouteDecoder route) async {
//     final authController = Get.find<AuthController>();
    
//     if (authController.currentUser.value == null && route.page != LoginPage) {
//       return RouteDecoder.fromRoute('/login');
//     }
//     return await super.redirect(route);
//   }
// }