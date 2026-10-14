import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restau_app/auth/forgot_password.dart';
import 'package:restau_app/auth/register.dart';
import 'package:restau_app/composants/CInput.dart';
import 'package:restau_app/home/controller_pacontroll/homePage.dart';
import '../composants/ElevattedButton.dart';
import '../style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      // Simulation d'un délai réseau
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connecté avec : ${_emailController.text.trim()}")),
      );
      Get.to(Homepage());
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Connexion réussie avec Google")),
    );
    Get.to(Homepage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/Tasty-logo.png",
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                Text(
                  "Heureux de vous revoir !",
                  style: KTypography.h3(context, color: KColors.tertiary),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Cinput(
                        controller: _emailController,
                        name: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          } else if (!isValidEmail(value)) {
                            return 'Format d\'email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Cinput(
                        controller: _passwordController,
                        name: "Mot de passe",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          } else if (!isValidPassword(value)) {
                            return 'Mot de passe trop faible (8 caractères, 1 majuscule, 1 chiffre)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.to(const ForgotPassword()),
                          child: Text(
                            "Mot de passe oublié ?",
                            style: KTypography.h6(context, color: KColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: Elevattedbutton(
                                onPressed: _login,
                                child: const Text("Se connecter"),
                              ),
                            ),
                      const SizedBox(height: 16),
                      // Bouton Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : _signInWithGoogle,
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 22,
                          ),
                          label: const Text("Continuer avec Google"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Get.to(const Register()),
                        child: Text(
                          "Pas de compte ? S'inscrire",
                          style: KTypography.h6(context, color: KColors.tertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
