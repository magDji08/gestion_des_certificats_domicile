import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/quartier_controller.dart';
import '../../models/quartier.dart';

class QuartierFormPage extends StatefulWidget {
  final Quartier? quartier;

  const QuartierFormPage({super.key, this.quartier});

  @override
  State<QuartierFormPage> createState() => _QuartierFormPageState();
}

class _QuartierFormPageState extends State<QuartierFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final QuartierController controller = Get.find();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.quartier != null) {
      _nomController.text = widget.quartier!.nom;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (widget.quartier == null) {
        await controller.createQuartier(_nomController.text);
      } else {
        final updatedQuartier = widget.quartier!.copyWith(
          nom: _nomController.text,
        );
        await controller.updateQuartier(updatedQuartier);
      }
      Get.back();
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quartier == null ? 'Nouveau Quartier' : 'Modifier Quartier'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du quartier',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          widget.quartier == null ? 'Créer' : 'Mettre à jour',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}