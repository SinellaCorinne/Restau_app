import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restau_app/auth/login.dart';
import 'package:restau_app/composants/CInput.dart';
import 'package:restau_app/composants/ElevattedButton.dart';

import '../style.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Les mots de passe ne correspondent pas")),
        );
        return;
      }

// Simuler la réinitialisation du mot de passe (en pratique, utiliser une API)
      await Future.delayed(const Duration(seconds: 2));

// Rediriger vers la page de connexion après réinitialisation
      Get.to(Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouveau mot de passe")),
      body:ListView(
    children:[ Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/Tasty-logo.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Cinput(
                controller: _newPasswordController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else if (!isValidPassword(value)) {
                    return 'Mot de passe trop faible (8 caractères, 1 majuscule, 1 chiffre)';
                  }
                  return null;
                }, name: 'Entrez un nouveau mot de passe',
              ),
              const SizedBox(height: 20),
              Cinput(
                controller: _confirmPasswordController,
                name: "Confirmer le mot de passe",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Elevattedbutton(
                onPressed: _resetPassword,
                child: const Text("Terminer"),
              ),
            ],
          ),
        ),
      ),
    ],
      ),
    );
  }
}
