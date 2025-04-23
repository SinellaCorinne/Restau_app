import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_plats_web/pages/admin_dashboard.dart';
import 'package:admin_plats_web/composant/elevattedbutton.dart';
import 'package:admin_plats_web/composant/Cinput.dart';
import 'package:admin_plats_web/theme/style.dart';

class AdminRegisterPage extends StatefulWidget {
  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String selectedRole = 'admin';

  final List<String> roles = ['admin', 'cuisinier', 'livreur'];

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Création de l'utilisateur
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Stockage du rôle dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'role': selectedRole,
        'createdAt': Timestamp.now(),
      });

      // Redirection après inscription
      Get.to(AdminDashboard());

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur d'inscription : ${e.toString()}")),
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
                  "Créer un compte Admin",
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

                const SizedBox(height: 10),

                /// Sélection du rôle
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Sélectionnez un rôle',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                /// Bouton d'inscription
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

                /// Lien vers la connexion
                TextButton(
                  onPressed: () {
                    Get.back(); // retourne à la page de connexion
                  },
                  child: const Text("Déjà un compte ? Se connecter"),
                )
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
