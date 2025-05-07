import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import '../components/c_input.dart';
import '../components/elevatted_button.dart';
import '../style.dart';
import 'admin_dashboard.dart';
import 'admin_register.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final dio_package.Dio _dio = dio_package.Dio();

  bool isLoading = false;

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
        var responseText = ""; // Réinitialiser le message
      });

      try {
        dio_package.Response response = await _dio.post(
          'http://192.168.100.192:8000/api/login', // Remplace par l'adresse IP réelle
          data: {
            "email": _emailController.text,
            "password": _passwordController.text,
          },
        );

        print("Réponse API: ${response.data}");

        // ✅ Adapte ici selon la réponse réelle du backend
        String message = response.data['message'] ?? "Connexion réussie";
        String email = response.data['email'] ?? _emailController.text;
        String token = response.data['token']; // Assure-toi que le token est renvoyé par l'API

        // Stocker le token dans GetStorage
       // if (token != null) {
       //   box.write('auth_token', token);
      //    print("Token stocké : $token");
        //}

        setState(() {

          isLoading = false;
        });

        // Redirection après connexion réussie
        Get.to(() => AdminDashboard());
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
                  "Espace Admin !",
                  style: KTypography.h3(context, color: KColors.tertiary),
                ),
                const SizedBox(height: 24),

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

                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: Elevattedbutton(
                    onPressed: login,
                    child: const Text("Se connecter"),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Get.to(AdminRegister());
                  },
                  child: const Text("Pas de compte ? S'inscrire"),
                ),
                const SizedBox(height: 10,),
                Elevattedbutton(
                  onPressed: () {
                    Get.to(AdminDashboard());
                  },
                  child: const Text("Dashboard"),
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
