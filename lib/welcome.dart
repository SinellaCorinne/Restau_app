import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restau_app/auth/login.dart';
import 'package:restau_app/composants/ElevattedButton.dart';
import 'package:restau_app/home/controller_pacontroll/homePage.dart';
import 'package:restau_app/style.dart';
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: KColors.primary,
      body:
      Padding(padding: const EdgeInsets.all(8.0),
      //Get.to(() => Welcome())
      child:
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/Tasty-logo.png"),
            ),
            Elevattedbutton(
              
                child: Text("Explorer"),
                backgroundColor: Colors.white,
                foregroundColor: KColors.primary,
                onPressed: () => Get.to(Login())
            ),
          ],
        ),
      ),),

    );
  }
}
