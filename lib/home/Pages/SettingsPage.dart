import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../composants/CListTile.dart';
import '../../composants/ElevattedButton.dart';
import '../../style.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Modifier vos paramètres",style: KTypography.h3(context,color:KColors.tertiary),),
            SizedBox(
              height: 20,
            ),
            CListTile(
              title: "Changer le mot de passe",
              icon: Iconsax.security,

            ),
            SizedBox(height:10),
            CListTile(
              title: "Notifications",
              icon: Iconsax.notification,

            ),
            SizedBox(height:10),
            CListTile(
              title: "Langue",
              icon: Iconsax.pen_add,

            ),
            SizedBox(height:10),
            CListTile(
              title: "Changer le mot de passe",
              icon: Iconsax.pen_add,

            ),
            SizedBox(height:10),
            CListTile(
              title: "Notifications",
              icon: Iconsax.pen_add,

            ),
            SizedBox(height:10),
            CListTile(
              title: "Langue",
              icon: Iconsax.pen_add,


            ),
            SizedBox(height: 30),
            Elevattedbutton(
              foregroundColor: Colors.white,
              onPressed: () {
                // Action pour enregistrer les paramètres
                print("Enregistrer les paramètres");
              },
              child: Text("Enregistrer les paramètres"),
            ),
          ],
        ),
      ),
    );
  }
}
