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
        title: const Text('Gestion des Quartiers',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () => Get.to(() => QuartierFormPage(), binding: QuartierBinding()),
            tooltip: 'Ajouter un quartier',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (controller.quartiers.isEmpty) {
            return _buildEmptyState();
          }
          return _buildQuartierList();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => QuartierFormPage()),
      ),
    );
  }

  Widget _buildEmptyState() {
  return FadeInDown(
    duration: const Duration(milliseconds: 600),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Aucun quartier enregistré',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_location),
            label: const Text('Ajouter un premier quartier'),
            onPressed: () => Get.to(() => QuartierFormPage()),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildQuartierList() {
    return ListView.separated(
      itemCount: controller.quartiers.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final quartier = controller.quartiers[index];
        return _buildQuartierCard(quartier);
      },
    );
  }

  Widget _buildQuartierCard(Quartier quartier) {
  return FadeInLeft(
    duration: const Duration(milliseconds: 500),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: const Icon(Icons.location_on_outlined, size: 30),
          title: Text(quartier.nom,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    'Créé le ${dateFormat.format(quartier.createdAt.toLocal())}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          trailing: _buildActionButtons(quartier),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          icon: Icon(Icons.edit_note, color: Colors.blue[700]),
          onPressed: () => Get.to(() => QuartierFormPage(quartier: quartier)),
        ),
        IconButton(
          icon: Icon(Icons.delete_forever, color: Colors.red[700]),
          onPressed: () => _confirmDelete(quartier.id!),
        ),
      ],
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce quartier ?'),
        actions: [
          TextButton(
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await controller.deleteQuartier(id);
              Get.back();
              Get.showSnackbar(GetSnackBar(
                messageText: const Text('Quartier supprimé avec succès',
                    style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                borderRadius: 15,
                margin: const EdgeInsets.all(15),
              ));
            },
          ),
        ],
      ),
    );
  }
}