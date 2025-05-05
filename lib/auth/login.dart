import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio_package;
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
  final dio_package.Dio dio = dio_package.Dio();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  dynamic responseText = "";

  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

 Future<void> _login() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      isLoading = true;
    });

    try {
      dio_package.Response response = await dio.post(
        'https://httpbin.org/post',// url à remplacer 
        data: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      String email = response.data['json']['email'];
      String password = response.data['json']['password'];

      setState(() {
        responseText = "Réponse : ${response.data.toString()}";
        isLoading = false;
      });

      Get.to(Homepage());
    } catch (e) {
      setState(() {
        responseText = "Erreur : $e";
        isLoading = false;
      });
    }
  }
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                onPressed:  _login,
                                child: const Text("Se connecter"),
                              ),
                            ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Get.to(ForgotPassword());
                        },
                        child: Text(
                          "Mot de passe oublié ?",
                          style: KTypography.h6(context,
                              color: KColors.tertiary),
                        ),
                      ),
                      Elevattedbutton(
                        onPressed: () {
                          Get.to(Register());
                        },
                        child: Text("Créer un compte",
                            style: KTypography.h6(context,
                                color: Colors.white)),
                      ),
                      const SizedBox(height: 50),
                      // Ce bouton est maintenant désactivé puisqu'on n’utilise plus Google
                      Elevattedbutton(
                        backgroundColor: Colors.white,
                        onPressed: Homepage.new,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 35),
                            Text(
                              "Se connecter avec Google",
                              style: KTypography.h4(context,
                                  color: KColors.primary),
                            ),
                          ],
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
