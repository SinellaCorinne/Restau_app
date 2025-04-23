import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/auth/login.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

 // Assurez-vous que Header est bien importé
class Homepage extends StatelessWidget {
  // Initialisation des contrôleurs
  final HomeController homeController = Get.put(HomeController.instance);
  final PanierController panierController = Get.put(PanierController());

  Homepage({super.key});

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirigez l'utilisateur vers la page de connexion ou effectuez toute autre action nécessaire après la déconnexion
      print("Déconnexion réussie");
      Get.to(Login());
    } catch (e) {
      print("Erreur lors de la déconnexion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // AppBar avec Header personnalisé
      appBar: Header(
        onProfileTap: () {
          // Action au clic sur l'icône utilisateur, redirection vers la page des informations de l'utilisateur
          Get.to(UserInfoPage());
        },
      ),
      // Body avec SafeArea
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
      // Drawer avec les options du menu
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Erreur lors de la récupération des données."));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Données introuvables."));
                }

                final userData = snapshot.data!.data()!;
                final nom = userData['nom'] ?? 'Nom';
                final prenom = userData['prenom'] ?? 'Prénom';

                return DrawerHeader(
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
                          Text("Bienvenue,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                          SizedBox(height: 5),
                          Text("$prenom $nom", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => const SettingsPage()),
                      child: CListTile(
                        icon: Iconsax.setting_2,
                        title: 'Paramètres',
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => Get.to(() => const SuggestionsPage()),
                      child: CListTile(
                        icon: Iconsax.lamp_on,
                        title: 'Suggestions',
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: signOut,
                      child: CListTile(
                        icon: Iconsax.logout,
                        title: 'Déconnexion',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Obx(() => NavigationBar(
        backgroundColor: KColors.secondary,
        selectedIndex: homeController.curentIndex,
        onDestinationSelected: (value) {
          homeController.updateCurentIndex(value);
        },
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
