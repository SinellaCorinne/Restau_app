import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/auth/login.dart';

import '../../composants/CListTile.dart';
import '../../composants/ElevattedButton.dart';
import '../../composants/SettingItem.dart';
import '../../style.dart';
import 'SettingsPages/confidentialite_page.dart';
import 'SettingsPages/notification_page.dart';
import 'SettingsPages/pages_aide_page.dart';
import 'SettingsPages/personnaliser_page.dart';
import 'SettingsPages/termes_conditions_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: KTypography.h3(context,color: Colors.white)),
        backgroundColor: KColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Utilisation du composant Profil
              // Titre de la section des paramètres
              Text(
                'Paramètres',
                style: KTypography.h4(context, color: KColors.primary),
              ),
              SizedBox(height: 10),

              // Utilisation du composant SettingItem
              SettingItem(
                title: 'Personnaliser',
                leadingIcon:Iconsax.pen_add,
                trailingIcon:Iconsax.arrow_right,
                onTap: () {
                  Get.to(() => PersonnaliserPage());
                },
              ),
              SizedBox(height: 10),
              SettingItem(
                title: 'Notifications',
                leadingIcon:Iconsax.notification,
                trailingIcon:Iconsax.arrow_right,
                onTap:  () {
                  Get.to(() => NotificationsPage());
                },
              ),
              SizedBox(height: 10),
              SettingItem(
                title: 'Confidentialité',
                leadingIcon:Iconsax.lock,
                trailingIcon:Iconsax.arrow_right,
                onTap:  () {
                  Get.to(() => ConfidentialitePage());
                },
              ),
              SizedBox(height: 10),
              SettingItem(
                title: 'Termes et Conditions',
                leadingIcon:Iconsax.document_text,
                trailingIcon:Iconsax.arrow_right,
                onTap:  () {
                  Get.to(() => TermesConditionsPage());
                },
              ),
              SizedBox(height: 10),
              SettingItem(
                title: 'Pages d\'aide',
                leadingIcon:Iconsax.info_circle,
                trailingIcon:Iconsax.arrow_right,
                onTap:  () {
                  Get.to(() => PagesAidePage());
                },
              ),
              SizedBox(height: 30),
              Elevattedbutton(
                child: Text("Déconnexion"),
                onPressed: () {
                  Get.to(() => Login()); // Utilisez Get.to pour la navigation
                },
                backgroundColor: KColors.primary,
                borderColor: KColors.primary,
                foregroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
