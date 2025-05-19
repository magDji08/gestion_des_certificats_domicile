import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/certificat.dart';
import '../../controllers/certificat_controller.dart';
import '../../models/personne.dart';

class CertificatFormPage extends StatelessWidget {
  final CertificatController controller = Get.find();
  final PersonneController personneController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final RxInt selectedPersonneId = 0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString selectedPaymentMethod = ''.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxBool isLoading = false.obs;

  final Certificat? certificat;
  final double certificatPrice = 200.0; // Prix fixe du certificat

  CertificatFormPage({super.key, this.certificat}) {
    if (certificat != null) {
      numeroController.text = certificat!.numero;
      selectedPersonneId.value = certificat!.personneId;
      selectedDate.value = certificat!.dateEmission;
    }
  }

  Future<bool> _processPayment() async {
    isProcessingPayment.value = true;
    
    try {
      // Simulation du processus de paiement
      await Future.delayed(const Duration(seconds: 2));
      
      // Ici vous intégrerez le vrai SDK de paiement
      switch (selectedPaymentMethod.value) {
        case 'wave':
          // Intégration avec l'API Wave
          await _processWavePayment();
          break;
        case 'orange':
          // Intégration avec l'API Orange Money
          await _processOrangeMoneyPayment();
          break;
        case 'card':
          // Intégration avec une passerelle de paiement
          await _processCardPayment();
          break;
      }
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur de paiement', 
        'Le paiement a échoué: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  // Méthodes simulées pour le paiement
  Future<void> _processWavePayment() async {
    // Implémentez l'intégration avec Wave ici
    print('Paiement de $certificatPrice FCFA via Wave');
  }

  Future<void> _processOrangeMoneyPayment() async {
    // Implémentez l'intégration avec Orange Money ici
    print('Paiement de $certificatPrice FCFA via Orange Money');
  }

  Future<void> _processCardPayment() async {
    // Implémentez l'intégration avec la passerelle de carte ici
    print('Paiement de $certificatPrice FCFA via Carte Bancaire');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = certificat != null;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Modifier Certificat' : 'Nouveau Certificat',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Information du Certificat
                _buildSectionHeader(context, 'Informations du Certificat'),
                
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Sélection de la personne
                        _buildPersonneSelector(),
                        
                        const SizedBox(height: 16),
                        
                        // Numéro du certificat
                        _buildInputField(
                          controller: numeroController,
                          label: 'Numéro du certificat',
                          icon: Icons.numbers,
                          validator: (value) => value!.isEmpty ? 'Le numéro du certificat est requis' : null,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Date d'émission
                        _buildDateSelector(context),
                      ],
                    ),
                  ),
                ),
                
                // Section Paiement (seulement pour la création)
                if (!isEditing) ...[
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader(
                    context, 
                    'Informations de Paiement',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // const Icon(Icons.attach_money, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            '$certificatPrice FCFA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Modes de paiement
                  _buildPaymentMethods(),
                ],
                
                const SizedBox(height: 32),
                
                // Bouton d'action
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isProcessingPayment.value || isLoading.value)
                          ? Colors.grey
                          : theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: (isProcessingPayment.value || isLoading.value)
                        ? null
                        : _submitForm,
                    child: (isProcessingPayment.value || isLoading.value)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isProcessingPayment.value ? 'Traitement du paiement...' : 'Traitement en cours...',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(isEditing ? Icons.update : Icons.payment),
                              const SizedBox(width: 12),
                              Text(
                                isEditing 
                                  ? 'Mettre à jour le certificat' 
                                  : 'Payer et générer le certificat',
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
    );
  }

  // Méthode pour construire l'en-tête de section
  Widget _buildSectionHeader(BuildContext context, String title, {Widget? trailing}) {
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
          const Spacer(),
          if (trailing != null) trailing,
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

  // Méthode pour construire le sélecteur de personnes
  Widget _buildPersonneSelector() {
    return Obx(() {
      final List<Personne> habitants = personneController.habitants;
      
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButtonFormField<int>(
          value: selectedPersonneId.value != 0 ? selectedPersonneId.value : null,
          decoration: InputDecoration(
            labelText: 'Habitant',
            prefixIcon: const Icon(Icons.person_outline),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          items: habitants.map((p) => DropdownMenuItem(
            value: p.id,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getAvatarColor(p.nom),
                  radius: 14,
                  child: Text(
                    _getInitials(p.nom, p.prenom),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${p.nom} ${p.prenom}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )).toList(),
          onChanged: (val) => selectedPersonneId.value = val!,
          validator: (val) => val == null ? 'La sélection d\'un habitant est requise' : null,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      );
    });
  }

  // Méthode pour construire le sélecteur de date
  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate.value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
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
          selectedDate.value = pickedDate;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Obx(() => Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date d\'émission',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMMM yyyy', 'fr_FR').format(selectedDate.value),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        )),
      ),
    );
  }

  // Méthode pour construire les options de paiement
  Widget _buildPaymentMethods() {
    return Obx(() {
      final hasSelectedPayment = selectedPaymentMethod.value.isNotEmpty;
      
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.payment, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text(
                    'Mode de paiement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (hasSelectedPayment)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          const Text(
                            'Sélectionné',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Choisissez votre méthode de paiement préférée:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              
              const SizedBox(height: 12),
              
              _buildPaymentMethodCard(
                image: 'assets/wave_logo.png',
                title: 'Wave',
                description: 'Paiement rapide via votre compte Wave',
                isSelected: selectedPaymentMethod.value == 'wave',
                onTap: () => selectedPaymentMethod.value = 'wave',
              ),
              
              const SizedBox(height: 8),
              
              _buildPaymentMethodCard(
                image: 'assets/orange_money_logo.png',
                title: 'Orange Money',
                description: 'Paiement sécurisé via Orange Money',
                isSelected: selectedPaymentMethod.value == 'orange',
                onTap: () => selectedPaymentMethod.value = 'orange',
              ),
              
              const SizedBox(height: 8),
              
              _buildPaymentMethodCard(
                image: 'assets/carte_bancaire_logo.png',
                title: 'Carte Bancaire',
                description: 'VISA, Mastercard et cartes locales acceptées',
                isSelected: selectedPaymentMethod.value == 'card',
                onTap: () => selectedPaymentMethod.value = 'card',
              ),
              
              if (!hasSelectedPayment) ...[
                const SizedBox(height: 12),
                const Text(
                  'Veuillez sélectionner un mode de paiement pour continuer',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  // Méthode pour construire un mode de paiement
  Widget _buildPaymentMethodCard({
    required String image,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      margin: EdgeInsets.zero,
      color: isSelected 
          ? Theme.of(Get.context!).primaryColor.withOpacity(0.1) 
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? Theme.of(Get.context!).primaryColor 
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? Theme.of(Get.context!).primaryColor 
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (certificat == null && selectedPaymentMethod.value.isEmpty) {
        Get.snackbar(
          'Attention', 
          'Veuillez sélectionner un mode de paiement',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
        return;
      }
      
      isLoading.value = true;
      
      try {
        // Processus de paiement si c'est une création
        if (certificat == null) {
          final paymentSuccess = await _processPayment();
          if (!paymentSuccess) {
            isLoading.value = false;
            return;
          }
        }
        
        // Création ou mise à jour du certificat
        final certif = Certificat(
          id: certificat?.id,
          personneId: selectedPersonneId.value,
          numero: numeroController.text.trim(),
          dateEmission: selectedDate.value,
        );

        if (certificat == null) {
          await controller.createCertificat(certif);
          Get.back();
          Get.snackbar(
            'Succès',
            'Certificat créé avec succès',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        } else {
          await controller.updateCertificat(certif);
          Get.back();
          Get.snackbar(
            'Succès',
            'Certificat mis à jour avec succès',
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

  // Méthodes utilitaires
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
}