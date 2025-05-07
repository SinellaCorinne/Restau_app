import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../components/c_input.dart';
import '../components/elevatted_button.dart';
import '../style.dart';
import 'admin_dashboard.dart';

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }
  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }
  bool isValidPhone(String phone) {
    String phonePattern = r'^\+?[1-9]\d{1,14}$'; // Format international
    return RegExp(phonePattern).hasMatch(phone);}
  final Dio dio = Dio();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        dio_package.Response response = await dio.post(
          'http://192.168.100.192:8000/api/register',
          data: {
            "nom": _lastNameController.text.trim(),             // Nom
            "prenom": _firstNameController.text.trim(),         // Prénom
            "telephone": _phoneController.text.trim(),          // Téléphone
            "email": _emailController.text.trim(),              // Email
            "password": _passwordController.text.trim(),        // Mot de passe
            "password_confirmation": _confirmPasswordController.text.trim(),  // ⚠️ Ce champ est requis par Laravel
          },
          options: dio_package.Options(
            headers: {
              'Accept': 'application/json',
            },
          ),
        );

        // Tu peux ici adapter selon la structure exacte de ta réponse Laravel
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inscription réussie")),
        );

        Get.to(AdminDashboard());

      } catch (e) {
        print("Erreur : $e");
        setState(() {
          isLoading = false;
        });

        // Affichage d'un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'inscription : $e")),
        );
      }
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

                // Champ Prénom
                Cinput(
                  controller: _lastNameController,
                  name: "Nom",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Champ Nom
                Cinput(
                  controller: _firstNameController,
                  name: "Prénom",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Champ Email
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
                // Champ Numéro de téléphone
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
                // Champ Mot de passe
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
                // Champ Confirmation du mot de passe
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

  }

