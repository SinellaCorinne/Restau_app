import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_app/pages/admin_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminLogin(),
    );
  }
}
