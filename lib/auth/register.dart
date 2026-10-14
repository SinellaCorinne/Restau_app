import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restau_app/home/controller_pacontroll/homePage.dart';
import '../composants/CInput.dart';
import '../composants/ElevattedButton.dart';
import '../style.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  bool isValidEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);

  bool isValidPassword(String password) =>
      RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);

  bool isValidPhone(String phone) =>
      RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      // Simulation d'un délai réseau
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription réussie")),
      );
      Get.to(Homepage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Column(
            children: [
              Image.asset(
                "assets/images/Tasty-logo.png",
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              Text("Créer un compte",
                  style: KTypography.h3(context, color: KColors.tertiary)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Cinput(
                      controller: _lastNameController,
                      name: "Nom",
                      validator: (value) => value == null || value.isEmpty
                          ? 'Veuillez entrer votre nom'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Cinput(
                      controller: _firstNameController,
                      name: "Prénom",
                      validator: (value) => value == null || value.isEmpty
                          ? 'Veuillez entrer votre prénom'
                          : null,
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Cinput(
                      controller: _phoneController,
                      name: "Numéro de téléphone",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre numéro de téléphone';
                        } else if (!isValidPhone(value)) {
                          return 'Format de numéro invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Cinput(
                      controller: _confirmPasswordController,
                      name: "Confirmer le mot de passe",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        } else if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: Elevattedbutton(
                              onPressed: _register,
                              child: const Text("S'inscrire"),
                            ),
                          ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Get.to(Login()),
                      child: Text(
                        "Déjà un compte? Connectez-vous",
                        style: KTypography.h6(context, color: KColors.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
