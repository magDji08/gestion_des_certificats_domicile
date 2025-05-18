import 'package:certificat_management/controllers/personne_controlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/personne.dart';
// import '../../controllers/personne_controller.dart';
import '../../controllers/maison_controller.dart';

class PersonneFormPage extends StatelessWidget {
  final PersonneController personneController = Get.find();
  final MaisonController maisonController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final Personne? personne;
  final RxString role = ''.obs;
  final RxInt selectedMaisonId = 0.obs;

  PersonneFormPage({super.key, this.personne}) {
    if (personne != null) {
      nomController.text = personne!.nom;
      telController.text = personne!.telephone;
      emailController.text = personne!.email;
      role.value = personne!.role;
      selectedMaisonId.value = personne!.maisonId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personne == null ? 'Ajouter une Personne' : 'Modifier une Personne'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: telController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                Obx(() => DropdownButtonFormField<String>(
                      value: role.value.isNotEmpty ? role.value : null,
                      decoration: const InputDecoration(labelText: 'Rôle'),
                      items: ['proprietaire', 'habitant']
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (val) => role.value = val!,
                      validator: (val) => val == null ? 'Champ requis' : null,
                    )),
                const SizedBox(height: 12),
                Obx(() => DropdownButtonFormField<int>(
                      value: selectedMaisonId.value != 0 ? selectedMaisonId.value : null,
                      decoration: const InputDecoration(labelText: 'Maison'),
                      items: maisonController.maisons
                          .map((m) => DropdownMenuItem(value: m.id, child: Text(m.adresse)))
                          .toList(),
                      onChanged: (val) => selectedMaisonId.value = val!,
                      validator: (val) => val == null ? 'Champ requis' : null,
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final newPersonne = Personne(
                          id: personne?.id,
                          nom: nomController.text.trim(),
                          telephone: telController.text.trim(),
                          email: emailController.text.trim(),
                          role: role.value,
                          maisonId: selectedMaisonId.value,
                        );

                        if (personne == null) {
                          await personneController.createPersonne(newPersonne);
                        } else {
                          await personneController.updatePersonne(newPersonne);
                        }

                        Get.back();
                      }
                    },
                    child: Text(personne == null ? 'Enregistrer' : 'Mettre à jour'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}