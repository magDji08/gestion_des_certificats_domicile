import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/certificat.dart';
import '../../controllers/certificat_controller.dart';
import '../../controllers/personne_controlller.dart';

class CertificatFormPage extends StatelessWidget {
  final CertificatController controller = Get.find();
  final PersonneController personneController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController numeroController = TextEditingController();
  final RxInt selectedPersonneId = 0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final Certificat? certificat;

  CertificatFormPage({super.key, this.certificat}) {
    if (certificat != null) {
      numeroController.text = certificat!.numero;
      selectedPersonneId.value = certificat!.personneId;
      selectedDate.value = certificat!.dateEmission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(certificat == null ? 'Nouveau Certificat' : 'Modifier Certificat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() => DropdownButtonFormField<int>(
                    value: selectedPersonneId.value != 0 ? selectedPersonneId.value : null,
                    decoration: const InputDecoration(labelText: 'Habitant'),
                    items: personneController.habitants
                        .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom)))
                        .toList(),
                    onChanged: (val) => selectedPersonneId.value = val!,
                    validator: (val) => val == null ? 'Champ requis' : null,
                  )),
              const SizedBox(height: 12),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Numéro du certificat'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              Obx(() => Row(
                    children: [
                      Text('Date: ${selectedDate.value.toLocal().toString().split(' ')[0]}'),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) selectedDate.value = date;
                        },
                        child: const Text('Choisir'),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final certif = Certificat(
                        id: certificat?.id,
                        personneId: selectedPersonneId.value,
                        numero: numeroController.text.trim(),
                        dateEmission: selectedDate.value,
                      );

                      if (certificat == null) {
                        await controller.createCertificat(certif);
                      } else {
                        await controller.updateCertificat(certif);
                      }
                      Get.back();
                    }
                  },
                  child: Text(certificat == null ? 'Créer' : 'Mettre à jour'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}