import 'package:certificat_management/pages/personne/personne_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/personne_controlller.dart';
import '../../controllers/maison_controller.dart';
import '../../models/personne.dart';

class PersonneListPage extends StatelessWidget {
  final PersonneController personneController = Get.find();
  final MaisonController maisonController = Get.find();

  PersonneListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Personnes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implémenter la recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implémenter le filtrage
            },
          ),
        ],
      ),
      body: Obx(() {
        // if (personneController.isLoading.isTrue) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        
        if (personneController.personnes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune personne enregistrée',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une personne'),
                  onPressed: () => Get.to(() => PersonneFormPage()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: ListView.builder(
            itemCount: personneController.personnes.length,
            itemBuilder: (context, index) {
              final personne = personneController.personnes[index];
              final maison = maisonController.maisons
                  .firstWhereOrNull((m) => m.id == personne.maisonId);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPersonneCard(personne, maison, context),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => PersonneFormPage()),
        icon: const Icon(Icons.person_add),
        label: const Text('Nouvelle personne'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildPersonneCard(Personne personne, dynamic maison, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Afficher plus de détails ou naviguer vers une page de détails
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getAvatarColor(personne.nom),
                    child: Text(
                      _getInitials(personne.nom, personne.prenom),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${personne.nom} ${personne.prenom}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          personne.role,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.to(() => PersonneFormPage(personne: personne));
                      } else if (value == 'delete') {
                        _confirmDelete(personne.id!);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Modifier'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Supprimer'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(Icons.phone, personne.telephone),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.home, maison?.adresse ?? "Adresse non assignée"),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.cake, 'Né(e) le ${personne.dateNaissance}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, personne.lieuNaissance),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  String _getInitials(String nom, String prenom) {
    String initials = '';
    if (nom.isNotEmpty) initials += nom[0];
    if (prenom.isNotEmpty) initials += prenom[0];
    return initials.toUpperCase();
  }

  Color _getAvatarColor(String nom) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    int hash = 0;
    for (int i = 0; i < nom.length; i++) {
      hash = nom.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    return colors[hash.abs() % colors.length];
  }

  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmation de suppression'),
        content: const Text('Voulez-vous vraiment supprimer cette personne ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            label: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await personneController.deletePersonne(id);
              Get.back();
              Get.snackbar(
                'Suppression réussie',
                'La personne a été supprimée avec succès',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }
}