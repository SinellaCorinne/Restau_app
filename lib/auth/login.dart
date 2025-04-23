import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'as dio_package;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restau_app/auth/forgot_password.dart';
import 'package:restau_app/auth/register.dart';
import 'package:restau_app/composants/CInput.dart';
import 'package:restau_app/home/controller_pacontroll/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Validation de l'email correspondant au format exemple@gmail.com
  bool isValidEmail(String email) {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  // Validation du mot de passe : minimum 8 caractères, une majuscule et un chiffre
  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connecté avec : ${userCredential.user?.email}")),
        );

        Get.to(Homepage());
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });

        String message = '';
        switch (e.code) {
          case 'user-not-found':
            message = 'Aucun utilisateur trouvé avec cet email.';
            break;
          case 'wrong-password':
            message = 'Mot de passe incorrect.';
            break;
          default:
            message = e.message ?? 'Erreur inconnue';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $message")),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return; // L'utilisateur a annulé
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await FirebaseAuth.instance.signInWithCredential(credential);

      // Récupération des infos de profil
      final additionalUserInfo = result.additionalUserInfo;
      final profile = additionalUserInfo?.profile;

      final String? prenom = profile?['given_name'];
      final String? nom = profile?['family_name'];
      final String? email = profile?['email'];
      final String? photoUrl = profile?['picture'];
      final String? uid = result.user?.uid;

      // Enregistrement dans Firestore
      if (uid != null) {
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'prenom': prenom,
          'nom': nom,
          'email': email,
          'photoUrl': photoUrl,
          'uid': uid,
          'createdAt': Timestamp.now(),
        });
      }

      // Snack de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion réussie avec Google")),
      );

      // Redirection
      Get.to(Homepage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur Google: $e")),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: ListView(
        children:[ Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Image.asset(
                "assets/images/Tasty-logo.png",
                width: 180,   // largeur souhaitée
                height: 180,  // hauteur souhaitée
                fit: BoxFit.contain, // pour bien contenir l'image sans la déformer
              ),

              Text("Heureux de vous revoir !",style: KTypography.h3(context, color: KColors.tertiary),),

              SizedBox(height: 40,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Champ Email
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
                    // Champ Mot de passe
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

                    // Bouton de chargement ou bouton Connexion
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
                    // Lien Mot de passe oublié
                    TextButton(
                      onPressed: () {
                        Get.to(ForgotPassword());
                        //Navigator.pushNamed(context, '/forgot-password');
                      },
                      child:  Text("Mot de passe oublié ?", style: KTypography.h6(context, color: KColors.tertiary),),
                    ),
                    // Lien Inscription
                    Elevattedbutton(
                      onPressed: () {
                        Get.to(Register());
                        //Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Créer un compte", style: KTypography.h6(context, color: Colors.white)),
                    ),
                    SizedBox(height: 50,),
                  Elevattedbutton(
                    backgroundColor: Colors.white,
  onPressed: _signInWithGoogle,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/google_logo.png',  // L'icône de Google en local
        width: 20,
        height: 20,
      ),
      const SizedBox(width: 35), // Espacement entre l'icône et le texte
      Text(
        "Se connecter avec Google",
        style: KTypography.h4(context, color: KColors.primary),
      ),
    ],
  ),
),


                   


                  ],
                ),
              ),
            ],
          ),
        ),]
      ),
    );
  }
}
