import 'package:certificat_management/pages/auth/login_page.dart';
import 'package:certificat_management/pages/certificat/list_page.dart';
import 'package:certificat_management/pages/maison/list_page.dart';
import 'package:certificat_management/pages/personne/personne_list_page.dart';
import 'package:certificat_management/pages/quartier/list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

// Import des controllers et bindings
import '../controllers/auth_controller.dart';
import '../bindings/auth_binding.dart';
import '../bindings/quartier_binding.dart';
import '../bindings/maison_binding.dart';
import '../bindings/personne_binding.dart';
import '../bindings/certificat_binding.dart';


class Dashboard extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  
  Dashboard({super.key});

  final DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'fr');
  final String currentDate = DateFormat('dd MMMM yyyy', 'fr').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    // Récupérer le rôle et le nom d'utilisateur depuis le contrôleur d'authentification
    // final String role = authController.userRole.value;
    // final String username = authController.username.value;
    final String role = authController.currentUser.value!.role;
    final String username = authController.currentUser.value!.username;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1150BD),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(username, role),
            const SizedBox(height: 20),
            Expanded(
              child: _buildDashboardContent(role),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String username, String role) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      children: [
                        Text(
                          "Bonjour, $username",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        const Text(
                          " 👋",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRoleIcon(role),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _getRoleDisplay(role),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      currentDate,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[100],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              FadeInRight(
                duration: const Duration(milliseconds: 800),
                child: InkWell(
                  onTap: () => _showUserProfileDialog(),
                  customBorder: const CircleBorder(),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.person,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Rechercher ${_getSearchPlaceholder(role)}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(String role) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Menu Principal",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.apps,
                        color: Colors.blue[800],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    children: [
                      // Affichage des blocs statistiques pour admin et agent
                      if (role == 'admin' || role == 'agent') _buildStatisticsSection(),
                      
                      const SizedBox(height: 25),
                      _buildModulesGrid(role),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, bottom: 15),
          child: Text(
            "Statistiques",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Quartiers",
                "12",
                Icons.location_city,
                Colors.indigo,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Maisons",
                "48",
                Icons.home,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Propriétaires",
                "32",
                Icons.person,
                Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                "Certificats",
                "27",
                Icons.description,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(String role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 15),
          child: Text(
            _getModuleSectionTitle(role),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
        ),
        // Premier rang de modules
        Row(
          children: [
            if (role == 'admin' || role == 'agent')
              Expanded(
                child: _buildModuleCard(
                  title: 'Quartiers',
                  icon: Icons.location_city,
                  color: Colors.teal,
                  onTap: () => Get.to(() => QuartierListPage(), binding: QuartierBinding()),
                ),
              ),
            if (role == 'admin' || role == 'agent') const SizedBox(width: 15),
            Expanded(
              child: _buildModuleCard(
                title: 'Maisons',
                icon: Icons.home,
                color: Colors.deepOrange,
                onTap: () => Get.to(() => MaisonListPage(), binding: MaisonBinding()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Deuxième rang de modules
        Row(
          children: [
            if (role == 'admin')
              Expanded(
                child: _buildModuleCard(
                  title: 'Propriétaires',
                  icon: Icons.person,
                  color: Colors.deepPurple,
                  onTap: () => Get.to(() => PersonneListPage(), binding: PersonneBinding()),
                ),
              ),
            if (role == 'admin') const SizedBox(width: 15),
            Expanded(
              child: _buildModuleCard(
                title: 'Certificats',
                icon: Icons.description,
                color: Colors.blue,
                onTap: () => Get.to(() => CertificatListPage(), binding: CertificatBinding()),
              ),
            ),
          ],
        ),
        
        // Modules spécifiques au rôle citoyen
        if (role == 'citoyen') 
          Column(
            children: [
              const SizedBox(height: 15),
              _buildModuleCard(
                title: 'Mes Demandes',
                icon: Icons.assignment,
                color: Colors.amber,
                onTap: () => _handleNotImplemented('Mes Demandes'),
              ),
              const SizedBox(height: 15),
              _buildModuleCard(
                title: 'Suivi de Dossier',
                icon: Icons.track_changes,
                color: Colors.green,
                onTap: () => _handleNotImplemented('Suivi de Dossier'),
              ),
            ],
          ),
        
        // Module de support disponible pour tous les rôles
        const SizedBox(height: 20),
        _buildSupportCard(),
      ],
    );
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withOpacity(0.1),
      highlightColor: color.withOpacity(0.05),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1150BD).withOpacity(0.9),
            const Color(0xFF1150BD).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1150BD).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Besoin d'aide ?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Contactez notre support",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.phone,
              size: 22,
              color: const Color(0xFF1150BD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(Icons.home, "Accueil", true),
              _buildNavBarItem(Icons.dashboard, "Modules", false),
              _buildNavBarItem(Icons.history, "Historique", false),
              _buildNavBarItem(Icons.settings, "Réglages", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        // Gérer la navigation ici
        if (label != "Accueil") {
          _handleNotImplemented(label);
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1150BD).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF1150BD) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF1150BD) : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper functions
  String _getRoleDisplay(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrateur';
      case 'agent':
        return 'Agent Municipal';
      case 'citoyen':
        return 'Citoyen';
      default:
        return 'Utilisateur';
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'agent':
        return Icons.badge;
      case 'citoyen':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }

  String _getSearchPlaceholder(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'une information...';
      case 'agent':
        return 'un dossier...';
      case 'citoyen':
        return 'vos demandes...';
      default:
        return '...';
    }
  }

  String _getModuleSectionTitle(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Modules d\'Administration';
      case 'agent':
        return 'Modules de Gestion';
      case 'citoyen':
        return 'Services Disponibles';
      default:
        return 'Modules';
    }
  }

  void _showUserProfileDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF1150BD),
                child: Text(
                  authController.currentUser.value!.username.isNotEmpty 
                    ? authController.currentUser.value!.username.toUpperCase() 
                    : 'User',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                authController.currentUser.value!.username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1150BD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getRoleDisplay(authController.currentUser.value!.role),
                  style: const TextStyle(
                    color: Color(0xFF1150BD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Mon Profil'),
                onTap: () {
                  Get.back();
                  _handleNotImplemented('Profil');
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Paramètres'),
                onTap: () {
                  Get.back();
                  _handleNotImplemented('Paramètres');
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  _handleLogout();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotImplemented(String feature) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          'La fonctionnalité "$feature" sera bientôt disponible',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800]!,
        duration: const Duration(seconds: 3),
        borderRadius: 10,
        margin: const EdgeInsets.all(15),
        icon: const Icon(Icons.info_outline, color: Colors.white),
      ),
    );
  }

  void _handleLogout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Êtes-vous sûr de vouloir vous déconnecter ?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () => Get.back(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Déconnexter'),
                    onPressed: () {
                      // Logique de déconnexion
                      authController.logout();
                      Get.offAll(() => LoginPage(), binding: AuthBinding());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}