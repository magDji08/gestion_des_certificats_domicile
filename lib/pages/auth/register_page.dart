// lib/pages/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find();

  final RxString selectedRole = 'citoyen'.obs;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nom utilisateur'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButton<String>(
              value: selectedRole.value,
              items: ["citoyen", "agent"].map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.capitalizeFirst!),
              )).toList(),
              onChanged: (val) => selectedRole.value = val!,
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authController.register(
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                  selectedRole.value,
                );
                Get.back();
                Get.snackbar('Succès', 'Inscription réussie. Veuillez vous connecter.');
              },
              child: const Text("S'inscrire"),
            )
          ],
        ),
      ),
    );
  }
}