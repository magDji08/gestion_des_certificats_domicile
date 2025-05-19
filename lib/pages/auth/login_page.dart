import 'package:certificat_management/bindings/auth_binding.dart';
import 'package:certificat_management/dashboard.dart';
import 'package:certificat_management/main.dart';
import 'package:certificat_management/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:certificat_management/controllers/auth_controller.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  bool _isPasswordVisible = false;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec dégradé
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1150BD),
                          const Color(0xFF0D47A1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.2,
                            child: CustomPaint(
                              painter: CirclesPainter(),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/animations/login.json',
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Bienvenue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Connexion",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Accédez à votre espace personnel pour gérer vos certificats en toute sécurité.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Champ Email
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'exemple@email.com',
                                  icon: Icons.email_outlined,
                                  validator: (v) => v!.contains('@') ? null : 'Adresse email invalide',
                                ),
                                const SizedBox(height: 20),
                                // Champ Mot de passe
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'Mot de passe',
                                  hint: '••••••••',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: (v) => v!.length >= 6 ? null : '6 caractères minimum',
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Fonction pour mot de passe oublié
                                      Get.snackbar(
                                        'Info', 
                                        'Fonctionnalité en cours de développement',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.blue.withOpacity(0.1),
                                        colorText: Colors.blue,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      "Mot de passe oublié ?",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Bouton de connexion
                                _buildLoginButton(),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Option d'inscription
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Pas encore inscrit ? ",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  // onPressed: () => Get.toNamed('/register'),
                                  onPressed: () => Get.to(()=>RegisterPage(), binding: AuthBinding()),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Créer un compte",
                                    style: TextStyle(
                                      color: const Color(0xFF1150BD),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      validator: validator,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1150BD).withOpacity(0.7)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: const Color(0xFF1150BD), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade200),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
        floatingLabelStyle: TextStyle(
          color: const Color(0xFF1150BD),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF1150BD),
          elevation: 3,
          shadowColor: const Color(0xFF1150BD).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Ajout d'une animation au bouton
    _animationController.forward();

    try {
      final success = await _authController.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        Get.to(Dashboard());
      } else {
        Get.snackbar(
          'Échec de connexion', 
          'Email ou mot de passe incorrect',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade700,
          margin: EdgeInsets.all(15),
          borderRadius: 10,
          icon: Icon(Icons.error_outline, color: Colors.red.shade700),
          duration: Duration(seconds: 3),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
      _animationController.reverse();
    }
  }
}

// Peintre personnalisé pour l'arrière-plan avec des cercles
class CirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Dessiner plusieurs cercles de tailles différentes
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      size.width * 0.1,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.8),
      size.width * 0.15,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.08,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}