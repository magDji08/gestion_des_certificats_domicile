import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/personne.dart';
import '../../controllers/maison_controller.dart';

class PersonneFormPage extends StatelessWidget {
  final PersonneController personneController = Get.find();
  final MaisonController maisonController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController lieuNaissanceController = TextEditingController();

  final Personne? personne;
  final RxString role = ''.obs;
  final RxInt selectedMaisonId = 0.obs;
  final RxBool isLoading = false.obs;

  PersonneFormPage({super.key, this.personne}) {
    if (personne != null) {
      nomController.text = personne!.nom;
      prenomController.text = personne!.prenom;
      telController.text = personne!.telephone;
      dateNaissanceController.text = personne!.dateNaissance;
      lieuNaissanceController.text = personne!.lieuNaissance;
      role.value = personne!.role;
      selectedMaisonId.value = personne!.maisonId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = personne != null;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Modifier une Personne' : 'Ajouter une Personne',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête du formulaire
                  _buildSectionHeader(context, 'Informations personnelles'),
                  
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Champ Nom
                          _buildInputField(
                            controller: nomController,
                            label: 'Nom',
                            icon: Icons.person_outline,
                            validator: (value) => value!.isEmpty ? 'Le nom est requis' : null,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Champ Prénom
                          _buildInputField(
                            controller: prenomController,
                            label: 'Prénom',
                            icon: Icons.person_outline,
                            validator: (value) => value!.isEmpty ? 'Le prénom est requis' : null,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Champ Téléphone
                          _buildInputField(
                            controller: telController,
                            label: 'Téléphone',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) return 'Le téléphone est requis';
                              // Vous pouvez ajouter une validation de format ici
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section Naissance
                  _buildSectionHeader(context, 'Informations de naissance'),
                  
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Date de naissance
                          _buildDatePicker(context),
                          
                          const SizedBox(height: 16),
                          
                          // Lieu de naissance
                          _buildInputField(
                            controller: lieuNaissanceController,
                            label: 'Lieu de naissance',
                            icon: Icons.location_city_outlined,
                            validator: (value) => value!.isEmpty ? 'Le lieu de naissance est requis' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section Association
                  _buildSectionHeader(context, 'Rôle et Maison'),
                  
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Sélection du rôle
                          _buildRoleSelector(),
                          
                          const SizedBox(height: 16),
                          
                          // Sélection de la maison
                          _buildMaisonSelector(),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bouton d'enregistrement
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: isLoading.value ? null : _submitForm,
                      child: isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isEditing ? Icons.update : Icons.save),
                                const SizedBox(width: 12),
                                Text(
                                  isEditing ? 'Mettre à jour' : 'Enregistrer',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour construire l'en-tête de section
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire un champ de saisie
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Saisir $label',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  // Méthode pour construire le sélecteur de date
  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: dateNaissanceController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date de naissance',
        hintText: 'JJ/MM/AAAA',
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: (value) => value!.isEmpty ? 'La date de naissance est requise' : null,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          // Format de date
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          dateNaissanceController.text = formattedDate;
        }
      },
    );
  }

  // Méthode pour construire le sélecteur de rôle
  Widget _buildRoleSelector() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: role.value.isNotEmpty ? role.value : null,
            decoration: InputDecoration(
              labelText: 'Rôle',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items: [
              DropdownMenuItem(
                value: 'proprietaire',
                child: Row(
                  children: [
                    const Icon(Icons.home_work_outlined, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('Propriétaire'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'habitant',
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('Habitant'),
                  ],
                ),
              ),
            ],
            onChanged: (val) => role.value = val!,
            validator: (val) => val == null ? 'Le rôle est requis' : null,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white,
            isExpanded: true,
          ),
        ));
  }

  // Méthode pour construire le sélecteur de maison
  Widget _buildMaisonSelector() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<int>(
            value: selectedMaisonId.value != 0 ? selectedMaisonId.value : null,
            decoration: InputDecoration(
              labelText: 'Maison',
              prefixIcon: const Icon(Icons.home_outlined),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items: maisonController.maisons.map((m) => DropdownMenuItem(
              value: m.id,
              child: Text(
                m.adresse,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            )).toList(),
            onChanged: (val) => selectedMaisonId.value = val!,
            validator: (val) => val == null ? 'La maison est requise' : null,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white,
            isExpanded: true,
          ),
        ));
  }

  // Méthode pour soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;
      
      try {
        final newPersonne = Personne(
          id: personne?.id,
          nom: nomController.text.trim(),
          prenom: prenomController.text.trim(),
          telephone: telController.text.trim(),
          dateNaissance: dateNaissanceController.text.trim(),
          lieuNaissance: lieuNaissanceController.text.trim(),
          role: role.value,
          maisonId: selectedMaisonId.value,
        );

        if (personne == null) {
          await personneController.createPersonne(newPersonne);
          Get.back();
          Get.snackbar(
            'Succès',
            'Personne ajoutée avec succès',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        } else {
          await personneController.updatePersonne(newPersonne);
          Get.back();
          Get.snackbar(
            'Succès',
            'Personne mise à jour avec succès',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}