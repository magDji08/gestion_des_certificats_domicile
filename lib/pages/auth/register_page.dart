import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.find();

  final RxString selectedRole = 'citoyen'.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1150BD)),
          onPressed: () => Get.back(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration et titre
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1150BD).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          'assets/animations/login.json',
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Créer un compte",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Inscrivez-vous pour gérer vos certificats en toute sécurité",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Champs du formulaire
                _buildTextField(
                  controller: usernameController,
                  label: 'Nom d\'utilisateur',
                  hint: 'ex: mamadou123',
                  icon: Icons.person_outline,
                  validator: (v) => (v == null || v.length < 3) ? 'Au moins 3 caractères' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'exemple@email.com',
                  icon: Icons.email_outlined,
                  textInputType: TextInputType.emailAddress,
                  validator: (v) => v != null && v.contains('@') ? null : 'Email invalide',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: passwordController,
                  label: 'Mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  passwordVisible: _isPasswordVisible,
                  onTogglePasswordVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (v) => (v == null || v.length < 6) ? '6 caractères minimum' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: confirmPasswordController,
                  label: 'Confirmer le mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  passwordVisible: _isConfirmPasswordVisible,
                  onTogglePasswordVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  validator: (v) =>
                      (v != passwordController.text) ? 'Les mots de passe ne correspondent pas' : null,
                ),
                const SizedBox(height: 25),

                // Rôle
                Text("Rôle", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedRole.value,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(value: 'citoyen', child: Text('Citoyen')),
                            DropdownMenuItem(value: 'agent', child: Text('Agent')),
                          ],
                          onChanged: (val) => selectedRole.value = val!,
                        ),
                      ),
                    )),
                const SizedBox(height: 40),

                // Bouton de validation
                _buildRegisterButton(),

                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Déjà un compte ? Se connecter"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool passwordVisible = false,
    VoidCallback? onTogglePasswordVisibility,
    TextInputType textInputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !passwordVisible,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1150BD)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: onTogglePasswordVisibility,
              )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1150BD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Créer mon compte", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    _animationController.forward();

    try {
      await authController.register(
        usernameController.text.trim(),
        passwordController.text.trim(),
        selectedRole.value,
        emailController.text.trim(), // ✅ inclure email ici
      );

      Get.back();
      Get.snackbar(
        'Succès',
        'Votre compte a été créé avec succès.',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'inscription. Veuillez réessayer.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      setState(() => _isLoading = false);
      _animationController.reverse();
    }
  }
}
