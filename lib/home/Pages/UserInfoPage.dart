import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/home/Pages/EditUserInfoPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../style.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.secondary,
      appBar: AppBar(
        title: Text(
          "Mon Profil",
          style: KTypography.h3(context, color: Colors.white),
        ),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Une erreur s'est produite."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Données introuvables."));
          }

          final userData = snapshot.data!.data()!;
          final nom = userData['nom'] ?? '';
          final prenom = userData['prenom'] ?? '';
          final email = userData['email'] ?? '';
          final telephone = userData['telephone'] ?? '';
          final adresse = userData['adresse'] ?? '';
          final ville = userData['ville'] ?? '';
          final preferences = userData['preferences'] ?? '';
          final photoUrl = userData['photoUrl'] as String?;
          final createdAt = userData['createdAt']?.toDate() ?? DateTime.now();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
  child: CircleAvatar(
    radius: 80,
    backgroundColor: KColors.primary.withOpacity(0.1),
    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
        ? NetworkImage(photoUrl)
        : const AssetImage('assets/images/default_profile.png'),
  ),
),

                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(Iconsax.user, "Nom", "$nom $prenom"),
                        _buildInfoItem(Iconsax.sms, "Email", email),
                        _buildInfoItem(Iconsax.call, "Téléphone", telephone),
                        _buildInfoItem(Iconsax.home, "Adresse", adresse),
                        _buildInfoItem(Iconsax.location, "Ville", ville),
                        _buildInfoItem(Iconsax.setting_2, "Préférences", preferences),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: KColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Get.to(const EditUserInfoPage());
                    },
                    icon: const Icon(Iconsax.edit, color: Colors.white),
                    label: Text(
                      "Modifier mes informations",
                      style: KTypography.h6(context, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink(); // n’affiche rien si vide
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: KColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
