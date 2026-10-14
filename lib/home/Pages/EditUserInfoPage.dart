import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restau_app/mock/mock_data.dart';
import '../../style.dart';
import 'UserInfoPage.dart';

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({super.key});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adrController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController preferenceController = TextEditingController();

  bool isLoading = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    nomController.text = mockUser['nom'] ?? '';
    prenomController.text = mockUser['prenom'] ?? '';
    telephoneController.text = mockUser['telephone'] ?? '';
    adrController.text = mockUser['adresse'] ?? '';
    villeController.text = mockUser['ville'] ?? '';
    preferenceController.text = mockUser['preferences'] ?? '';
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => isLoading = false);

    Get.snackbar(
      "Succès",
      "Informations mises à jour avec succès !",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.off(() => UserInfoPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.secondary,
      appBar: AppBar(
        title: Text("Modifier mes infos",
            style: KTypography.h3(context, color: Colors.white)),
        backgroundColor: KColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!) as ImageProvider
                          : const AssetImage('assets/images/Tasty-logo.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Iconsax.camera,
                            color: KColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.user, "Nom", nomController),
              const SizedBox(height: 20),
              _buildTextField(
                  Iconsax.user_tick, "Prénom", prenomController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.home, "Adresse", adrController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.location, "Ville", villeController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.call, "Téléphone", telephoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField(
                  Iconsax.setting_2, "Préférences", preferenceController),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: KColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : _updateUserInfo,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Iconsax.save_2, color: Colors.white),
                  label: Text(
                    isLoading ? "Enregistrement..." : "Enregistrer",
                    style: KTypography.h6(context, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.trim().isEmpty
          ? "Ce champ est requis"
          : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: KColors.primary),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
