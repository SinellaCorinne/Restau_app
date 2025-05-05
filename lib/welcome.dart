import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restau_app/auth/login.dart';
import 'package:restau_app/composants/ElevattedButton.dart';
import 'package:restau_app/style.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Tasty-logo.png"),
              SizedBox(height: 24),
              Elevattedbutton(
                child: Text("Explorer"),
                backgroundColor: Colors.white,
                foregroundColor: KColors.primary,
                onPressed: () => Get.to(Login()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
