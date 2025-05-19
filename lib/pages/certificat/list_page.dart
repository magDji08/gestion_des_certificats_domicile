import 'package:certificat_management/pages/certificat/form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/certificat_controller.dart';
import '../../controllers/personne_controlller.dart';
import '../../utils/pdf_helper.dart';
// import '../../theme/app_colors.dart';

class CertificatListPage extends StatelessWidget {
  final CertificatController controller = Get.find();
  final PersonneController personneController = Get.find();
  
  CertificatListPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Certificats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implémentation de la recherche
              Get.snackbar(
                'Information',
                'Fonctionnalité de recherche à venir',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.secondary.withOpacity(0.8),
                colorText: Colors.white,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Implémentation du filtre
              _showFilterOptions(context);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return Center(
        //     child: CircularProgressIndicator(
        //       color: AppColors.primary,
        //     ),
        //   );
        // }
        
        if (controller.certificats.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildCertificatsList();
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(
          () => CertificatFormPage(),
          transition: Transition.rightToLeft,
        ),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nouveau',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun certificat disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez votre premier certificat',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => Get.to(
              () => CertificatFormPage(),
              transition: Transition.rightToLeft,
            ),
            child: const Text(
              'Créer un certificat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCertificatsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.certificats.length,
        itemBuilder: (context, index) {
          final certif = controller.certificats[index];
          final personne = personneController.personnes
              .firstWhereOrNull((p) => p.id == certif.personneId);
          
          // Format de la date
          String formattedDate = DateFormat('dd/MM/yyyy')
              .format(certif.dateEmission.toLocal());
          
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showCertificatDetails(context, certif, personne);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.verified_outlined,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Certificat #${certif.numero}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Émis le: $formattedDate',
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
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    Get.to(
                                      () => CertificatFormPage(certificat: certif),
                                      transition: Transition.rightToLeft,
                                    );
                                    break;
                                  case 'pdf':
                                    if (personne != null) {
                                      generateCertificatPdf(
                                        certif,
                                        personne.nom,
                                        "20-03-1999",  // Idéalement récupérer la date de naissance
                                        "PIKINE",
                                      );
                                      Get.snackbar(
                                        'Succès',
                                        'PDF généré avec succès',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.green.withOpacity(0.8),
                                        colorText: Colors.white,
                                        duration: const Duration(seconds: 2),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Erreur',
                                        'Aucune personne trouvée pour ce certificat',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.withOpacity(0.8),
                                        colorText: Colors.white,
                                      );
                                    }
                                    break;
                                  case 'delete':
                                    _confirmDelete(certif.id!);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'pdf',
                                  child: Row(
                                    children: [
                                      Icon(Icons.picture_as_pdf, color: Colors.green[700], size: 18),
                                      const SizedBox(width: 12),
                                      const Text('Générer PDF'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue[700], size: 18),
                                      const SizedBox(width: 12),
                                      const Text('Modifier'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, color: Colors.red[700], size: 18),
                                      const SizedBox(width: 12),
                                      const Text('Supprimer'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Bénéficiaire: ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              personne?.nom ?? 'Inconnu',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _showCertificatDetails(BuildContext context, dynamic certif, dynamic personne) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certificat #${certif.numero}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              'Bénéficiaire',
              personne?.nom ?? 'Inconnu',
              Icons.person_outline,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Date d\'émission',
              DateFormat('dd/MM/yyyy').format(certif.dateEmission.toLocal()),
              Icons.calendar_today_outlined,
            ),
            // Ajouter plus de détails si nécessaire
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text('Générer PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (personne != null) {
                        generateCertificatPdf(
                          certif,
                          personne.nom,
                          "20-03-1999",
                          "PIKINE",
                        );
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Erreur',
                          'Aucune personne trouvée pour ce certificat',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.edit_outlined, color: AppColors.primary),
                    label: Text(
                      'Modifier',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.to(() => CertificatFormPage(certificat: certif));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      _confirmDelete(certif.id!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showFilterOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtrer les certificats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.date_range, color: AppColors.primary),
              title: const Text('Par date d\'émission'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Implémenter le filtre par date
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person, color: AppColors.primary),
              title: const Text('Par bénéficiaire'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Implémenter le filtre par personne
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _confirmDelete(int id) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Êtes-vous sûr de vouloir supprimer ce certificat ? Cette action est irréversible.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.deleteCertificat(id);
                        Get.back();
                        Get.snackbar(
                          'Succès',
                          'Certificat supprimé avec succès',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Supprimer'),
                    ),
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

// Classe à ajouter dans un fichier séparé (theme/app_colors.dart)
class AppColors {
  static Color primary = const Color(0xFF3F51B5);    // Indigo
  static Color secondary = const Color(0xFF303F9F);  // Indigo foncé
  static Color accent = const Color(0xFF00BCD4);     // Cyan
  static Color background = const Color(0xFFF5F7FA); // Gris très clair
}