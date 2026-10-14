import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/home/Pages/EditUserInfoPage.dart';
import 'package:restau_app/mock/mock_data.dart';
import '../../style.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nom = mockUser['nom'] ?? '';
    final prenom = mockUser['prenom'] ?? '';
    final email = mockUser['email'] ?? '';
    final telephone = mockUser['telephone'] ?? '';
    final adresse = mockUser['adresse'] ?? '';
    final ville = mockUser['ville'] ?? '';
    final preferences = mockUser['preferences'] ?? '';
    final String? photoUrl = mockUser['photoUrl'] as String?;

    return Scaffold(
      backgroundColor: KColors.secondary,
      appBar: AppBar(
        title: Text("Mon Profil",
            style: KTypography.h3(context, color: Colors.white)),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: KColors.primary.withOpacity(0.1),
                backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl) as ImageProvider
                    : const AssetImage('assets/images/Tasty-logo.png'),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem(Iconsax.user, "Nom", "$nom $prenom"),
                    _buildInfoItem(Iconsax.sms, "Email", email),
                    _buildInfoItem(Iconsax.call, "Téléphone", telephone),
                    _buildInfoItem(Iconsax.home, "Adresse", adresse),
                    _buildInfoItem(Iconsax.location, "Ville", ville),
                    _buildInfoItem(
                        Iconsax.setting_2, "Préférences", preferences),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Get.to(const EditUserInfoPage()),
                icon: const Icon(Iconsax.edit, color: Colors.white),
                label: Text(
                  "Modifier mes informations",
                  style: KTypography.h6(context, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
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
                Text(title,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 14)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
