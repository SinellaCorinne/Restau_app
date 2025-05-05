import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔧 À ne pas oublier
import 'package:restau_app/composants/CInput.dart';
import 'package:restau_app/composants/ElevattedButton.dart';
import 'package:restau_app/style.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  Future<void> _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        Get.snackbar(
          "Succès",
          "Un e-mail de réinitialisation a été envoyé à ${_emailController.text}.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: KColors.primary,
          colorText: Colors.white,
        );
        Get.to(Login());
      } catch (e) {
        setState(() {
          isLoading = false;
        });

        Get.snackbar(
          "Erreur",
          "Impossible d'envoyer l'e-mail : ${e.toString()}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Réinitialisation du mot de passe")),
      body: ListView(
        children: [
          Padding(
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
                  Text(
                    "Entrez votre email pour réinitialiser votre mot de passe",
                    style: KTypography.h4(context, color: KColors.tertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Elevattedbutton(
                    onPressed: _sendResetLink,
                    child: const Text("Continuer"),
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
