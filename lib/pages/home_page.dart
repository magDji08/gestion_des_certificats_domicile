import 'package:certificat_management/bindings/maison_binding.dart';
import 'package:certificat_management/bindings/quartier_binding.dart';
import 'package:certificat_management/pages/maison/list_page.dart';
import 'package:certificat_management/pages/quartier/list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des Certificats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[100],
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              icon: Icons.location_city,
              title: 'Quartiers',
              // onTap: () => Get.toNamed('/quartiers'),
              // onTap: () => Get.to(QuartierListPage(), binding: QuartierBinding()),
              onTap: () => Get.to(() => QuartierListPage(), binding: QuartierBinding()),

              
              
              color: Colors.teal,
            ),
            _buildFeatureCard(
              icon: Icons.home,
              title: 'Maisons',
              // onTap: () => Get.toNamed('/maisons'),
              
              onTap: () => Get.to(() => MaisonListPage(), binding: MaisonBinding()),
              color: Colors.orange,
            ),
            _buildFeatureCard(
              icon: Icons.person,
              title: 'Propriétaires',
              onTap: () => Get.toNamed('/proprietaires'),
              color: Colors.purple,
            ),
            _buildFeatureCard(
              icon: Icons.people,
              title: 'Habitants',
              onTap: () => Get.toNamed('/habitants'),
              color: Colors.blue,
            ),
            _buildFeatureCard(
              icon: Icons.description,
              title: 'Certificats',
              onTap: () => Get.toNamed('/certificats'),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
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
}
