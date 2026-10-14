import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/auth/login.dart';
import 'package:restau_app/mock/mock_data.dart';
import 'package:restau_app/style.dart';
import '../../composants/CListTile.dart';
import '../../composants/Header.dart';
import '../Pages/Accueilc.dart';
import '../Pages/Commande.dart';
import '../Pages/Menu.dart';
import '../Pages/Reservation.dart';
import '../Pages/SettingsPage.dart';
import '../Pages/SuggestionsPage.dart';
import '../Pages/UserInfoPage.dart';
import 'home_controller.dart';
import '../controller_pacontroll/PanierController.dart';

class Homepage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController.instance);
  final PanierController panierController = Get.put(PanierController());

  Homepage({super.key});

  void signOut() {
    Get.offAll(() => Login());
  }

  @override
  Widget build(BuildContext context) {
    final String prenom = mockUser['prenom'] ?? 'Prénom';
    final String nom = mockUser['nom'] ?? 'Nom';

    return Scaffold(
      appBar: Header(
        onProfileTap: () => Get.to(UserInfoPage()),
      ),
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: homeController.curentIndex,
          children: [
            Accueilc(),
            Menu(),
            Commande(),
            Reservation(),
          ],
        )),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: KColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Iconsax.user, size: 32, color: KColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Bienvenue,",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$prenom $nom",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const SettingsPage()),
                      child: CListTile(icon: Iconsax.setting_2, title: 'Paramètres'),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => Get.to(() => const SuggestionsPage()),
                      child: CListTile(icon: Iconsax.lamp_on, title: 'Suggestions'),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: signOut,
                      child: CListTile(icon: Iconsax.logout, title: 'Déconnexion'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => NavigationBar(
        backgroundColor: KColors.secondary,
        selectedIndex: homeController.curentIndex,
        onDestinationSelected: homeController.updateCurentIndex,
        indicatorColor: KColors.primary,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home_trend_up), label: "Accueil"),
          NavigationDestination(icon: Icon(Iconsax.menu_board), label: "Menu"),
          NavigationDestination(icon: Icon(Iconsax.bag_tick), label: "Commandes"),
          NavigationDestination(icon: Icon(Iconsax.calendar_add), label: "Réservation"),
        ],
      )),
    );
  }
}
