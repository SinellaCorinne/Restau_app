import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restau_app/welcome.dart';
import 'home/controller_pacontroll/PanierController.dart';
import 'style.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Assurez-vous que Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez Firebase
  await Firebase.initializeApp();

  // Exécutez l'application avec MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanierController()),
        // Ajoutez d'autres providers ici si nécessaire
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: KColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: KColors.vertOlive,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: KColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: Welcome(),
    );
  }
}
