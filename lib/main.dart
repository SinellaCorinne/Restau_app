import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restau_app/home/controller_pacontroll/app_preferences.dart';
import 'package:restau_app/home/controller_pacontroll/PanierController.dart';
import 'package:restau_app/welcome.dart';
import 'style.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
/// 🔄 Handler pour les notifications en arrière-plan
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📥 Message reçu en arrière-plan (main.dart) : ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanierController()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
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
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    String? token = await FirebaseMessaging.instance.getToken();
    print("📲 Token FCM (main.dart) : $token");

    await FirebaseMessaging.instance.subscribeToTopic("all");

    // 🔁 Si l'app a été ouverte par une notification
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("🚀 Lancement via notification fermée : ${initialMessage.notification?.title}");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Notification en foreground : ${message.notification?.title}");
      final notification = message.notification;
      if (notification != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${notification.title ?? ''}: ${notification.body ?? ''}"),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📨 Notification ouverte (tap) : ${message.notification?.title}");
    });
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
