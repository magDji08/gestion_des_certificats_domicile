import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/maison_controller.dart';
// import '../../models/personne.dart';
import 'personne_form_page.dart';


class PersonneListPage extends StatelessWidget {
  final PersonneController personneController = Get.find();
  final MaisonController maisonController = Get.find();
  final RxString selectedRole = 'tous'.obs;

  PersonneListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Personnes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => DropdownButton<String>(
                  value: selectedRole.value,
                  isExpanded: true,
                  items: ['tous', 'proprietaire', 'habitant']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.capitalizeFirst!),
                          ))
                      .toList(),
                  onChanged: (val) => selectedRole.value = val!,
                )),
          ),
          Expanded(
            child: Obx(() {
              final personnes = selectedRole.value == 'tous'
                  ? personneController.personnes
                  : personneController.personnes
                      .where((p) => p.role == selectedRole.value)
                      .toList();

              if (personnes.isEmpty) {
                return const Center(child: Text('Aucune personne enregistrée'));
              }

              return ListView.builder(
                itemCount: personnes.length,
                itemBuilder: (context, index) {
                  final personne = personnes[index];
                  final maison = maisonController.maisons.firstWhereOrNull((m) => m.id == personne.maisonId)?.adresse ?? 'Inconnue';
                  return Card(
                    child: ListTile(
                      title: Text('${personne.nom} (${personne.role})'),
                      subtitle: Text('${personne.email} | Maison: $maison'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Get.to(() => PersonneFormPage(personne: personne)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(personne.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => PersonneFormPage()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Voulez-vous supprimer cette personne ?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () async {
            await personneController.deletePersonne(id);
            Get.back();
          },
          child: const Text('Supprimer'),
        ),
      ],
    ));
  }
}
