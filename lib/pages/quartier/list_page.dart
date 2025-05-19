
import 'package:animate_do/animate_do.dart';
import 'package:certificat_management/bindings/quartier_binding.dart';
import 'package:certificat_management/models/quartier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/quartier_controller.dart';
import 'form_page.dart';

class QuartierListPage extends StatelessWidget {
  final QuartierController controller = Get.find<QuartierController>();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy à HH:mm', 'fr');

  QuartierListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Gestion des Quartiers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => Get.to(
              () => QuartierFormPage(),
              binding: QuartierBinding(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            ),
            tooltip: 'Ajouter un quartier',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                // if (controller.isLoading.value) {
                //   return _buildLoadingState();
                // } else if (controller.quartiers.isEmpty) {
                //   return _buildEmptyState();
                // }
                return _buildQuartierList();
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Nouveau quartier'),
          elevation: 4,
          onPressed: () => Get.to(
            () => QuartierFormPage(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_city,
              size: 38,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    'Quartiers: ${controller.quartiers.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const SizedBox(height: 6),
                  const Text(
                    'Gérez tous vos quartiers facilement',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Theme.of(context).primaryColor,
              // onPressed: () => controller.fetchQuartiers(),
              onPressed: () => Null,
              tooltip: 'Rafraîchir la liste',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Chargement des quartiers...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_location.png', // Ajoutez cette image à votre projet
              height: 120,
              width: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.location_city,
                size: 100,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun quartier enregistré',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre premier quartier pour commencer',
              style: TextStyle(
                fontSize: 14, 
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.add_location),
              label: const Text(
                'Ajouter un quartier',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () => Get.to(
                () => QuartierFormPage(),
                transition: Transition.rightToLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuartierList() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.quartiers.length,
        itemBuilder: (context, index) {
          final quartier = controller.quartiers[index];
          // Utilisons des animations différentes selon la position
          return FadeInLeft(
            duration: Duration(milliseconds: 400 + (index * 50)),
            child: _buildQuartierCard(quartier, index),
          );
        },
      ),
    );
  }

  Widget _buildQuartierCard(Quartier quartier, int index) {
    final Color cardColor = index % 2 == 0 
        ? Colors.blue.withOpacity(0.05)
        : Colors.white;
        
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(
            () => QuartierFormPage(quartier: quartier),
            transition: Transition.rightToLeft,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(Get.context!).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quartier.nom,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today, 
                                size: 14, 
                                color: Colors.grey[600]
                              ),
                              const SizedBox(width: 6),
                              Text(
                                dateFormat.format(quartier.createdAt.toLocal()),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildActionButtons(quartier),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Quartier quartier) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit, color: Colors.blue, size: 20),
          ),
          onPressed: () => Get.to(
            () => QuartierFormPage(quartier: quartier),
            transition: Transition.rightToLeft,
          ),
          tooltip: 'Modifier',
          splashRadius: 24,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
          onPressed: () => _confirmDelete(quartier.id!),
          tooltip: 'Supprimer',
          splashRadius: 24,
        ),
      ],
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirmation de suppression',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Êtes-vous sûr de vouloir supprimer ce quartier ? Cette action est irréversible.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Annuler'),
                    onPressed: () => Get.back(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirmer la suppression'),
                    onPressed: () async {
                      await controller.deleteQuartier(id);
                      Get.back();
                      _showSuccessSnackbar('Quartier supprimé avec succès');
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

  void _showSuccessSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      ),
    );
  }
}