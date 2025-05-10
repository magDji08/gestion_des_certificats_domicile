import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/maison_controller.dart';
import '../../controllers/quartier_controller.dart';
import '../../models/maison.dart';

class MaisonFormPage extends StatelessWidget {
  final MaisonController maisonController = Get.find();
  final QuartierController quartierController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController adresseController = TextEditingController();
  RxInt selectedQuartierId = 0.obs;

  final Maison? maison;
  MaisonFormPage({super.key, this.maison}) {
    if (maison != null) {
      adresseController.text = maison!.adresse;
      selectedQuartierId.value = maison!.quartierId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maison == null ? 'Ajouter une Maison' : 'Modifier la Maison'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse de la maison',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Adresse requise' : null,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<int>(
                    value: selectedQuartierId.value != 0 ? selectedQuartierId.value : null,
                    items: quartierController.quartiers.map((q) {
                      return DropdownMenuItem<int>(
                        value: q.id,
                        child: Text(q.nom),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Sélectionner un quartier',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => selectedQuartierId.value = value!,
                    validator: (value) => value == null ? 'Quartier requis' : null,
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (maison == null) {
                        await maisonController.createMaison(
                          adresseController.text.trim(),
                          selectedQuartierId.value,
                        );
                      } else {
                        await maisonController.updateMaison(
                          maison!.copyWith(
                            adresse: adresseController.text.trim(),
                            quartierId: selectedQuartierId.value,
                          ),
                        );
                      }
                      Get.back();
                    }
                  },
                  child: Text(maison == null ? 'Enregistrer' : 'Mettre à jour'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
