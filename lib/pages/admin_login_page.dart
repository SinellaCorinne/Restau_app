import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_plats_web/pages/admin_dashboard.dart';
import 'package:admin_plats_web/composant/elevattedbutton.dart';
import 'package:admin_plats_web/composant/Cinput.dart';
import 'package:admin_plats_web/theme/style.dart';
import 'package:admin_plats_web/pages/admin_register_page.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Connexion de l'utilisateur
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Récupérer le rôle de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Redirection selon le rôle
        if (role == 'admin') {
          Get.to(AdminDashboard());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Utilisateur non trouvé")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion : ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/Tasty-logo.png",
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                Text(
                  "Espace Admin !",
                  style: KTypography.h3(context, color: KColors.tertiary),
                ),
                const SizedBox(height: 24),

                /// Email
                Cinput(
                  controller: _emailController,
                  name: "Entrez votre email",
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

                /// Mot de passe
                Cinput(
                  controller: _passwordController,
                  name: 'Mot de passe',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    } else if (!isValidPassword(value)) {
                      return 'Mot de passe trop faible (8 caractères, 1 majuscule, 1 chiffre)';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                /// Bouton
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: Elevattedbutton(
                    onPressed: _login,
                    child: const Text("Se connecter"),
                  ),
                ),

                const SizedBox(height: 10),

                /// Lien vers la page d'inscription
                TextButton(
                  onPressed: () {
                    Get.to(AdminRegisterPage()); // Lien vers la page d'inscription
                  },
                  child: const Text("Pas de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }
}
