import 'package:certificat_management/pages/certificat/form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/certificat_controller.dart';
import '../../controllers/personne_controlller.dart';
import '../../utils/pdf_helper.dart';

class CertificatListPage extends StatelessWidget {
  final CertificatController controller = Get.find();
  final PersonneController personneController = Get.find();

  CertificatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Certificats'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.certificats.isEmpty) {
          return const Center(child: Text('Aucun certificat enregistré'));
        }
        return ListView.builder(
          itemCount: controller.certificats.length,
          itemBuilder: (context, index) {
            final certif = controller.certificats[index];
            final personne = personneController.personnes.firstWhereOrNull((p) => p.id == certif.personneId);
            return Card(
              child: ListTile(
                title: Text('Certificat #${certif.numero}'),
                subtitle: Text('Habitant: ${personne?.nom ?? 'Inconnu'}\nÉmis le: ${certif.dateEmission.toLocal().toString().split(" ")[0]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.green),
                      onPressed: () {
                        if (personne != null) {
                          generateCertificatPdf(certif, personne.nom);
                        } else {
                          Get.snackbar('Erreur', 'Aucune personne trouvée pour ce certificat');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Get.to(() => CertificatFormPage(certificat: certif)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () => _confirmDelete(certif.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CertificatFormPage()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Supprimer ce certificat ?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () async {
            await controller.deleteCertificat(id);
            Get.back();
          },
          child: const Text('Supprimer'),
        ),
      ],
    ));
  }
}
