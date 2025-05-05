import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restau_app/home/controller_pacontroll/app_preferences.dart';
import 'package:restau_app/home/controller_pacontroll/PanierController.dart';
import 'package:restau_app/welcome.dart';
import 'style.dart';
/// 🔄 Handler pour les notifications en arrière-plan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanierController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
