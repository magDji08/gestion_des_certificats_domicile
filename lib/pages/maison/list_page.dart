// pages/maison/maison_list_page.dart
import 'package:certificat_management/pages/maison/form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/maison_controller.dart';
import '../../controllers/quartier_controller.dart';
// import '../../models/maison.dart';

class MaisonListPage extends StatelessWidget {
  final MaisonController maisonController = Get.find();
  final QuartierController quartierController = Get.find();
  final dateFormat = DateFormat('dd MMM yyyy à HH:mm', 'fr');

  MaisonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maisons'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (maisonController.maisons.isEmpty) {
            return Center(
              child: Text('Aucune maison enregistrée', style: TextStyle(color: Colors.grey[600])),
            );
          }
          return ListView.separated(
            itemCount: maisonController.maisons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final maison = maisonController.maisons[index];
              final quartierNom = quartierController.quartiers
                      .firstWhereOrNull((q) => q.id == maison.quartierId)
                      ?.nom ??
                  'Quartier inconnu';
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: const Icon(Icons.home, color: Colors.indigo),
                  ),
                  title: Text(maison.adresse, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Quartier : $quartierNom'),
                      Text('Ajoutée le ${dateFormat.format(maison.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey))
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Get.to(() => MaisonFormPage(maison: maison)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(maison.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => MaisonFormPage()),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous supprimer cette maison ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await maisonController.deleteMaison(id);
              Get.back();
              Get.snackbar('Succès', 'Maison supprimée avec succès', backgroundColor: Colors.green, colorText: Colors.white);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
