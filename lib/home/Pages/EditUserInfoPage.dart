import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../style.dart';
import 'UserInfoPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({super.key});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController adrController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController preferenceController = TextEditingController();

  bool isLoading = false;
  String? imageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      nomController.text = data['nom'] ?? '';
      prenomController.text = data['prenom'] ?? '';
      telephoneController.text = data['telephone'] ?? '';
      adrController.text = data['adresse'] ?? '';
      villeController.text = data['ville'] ?? '';
      preferenceController.text = data['preferences'] ?? '';
      imageUrl = data['photoUrl'];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
   const cloudName = "dmtutyn5e" ; // Remplace avec ton Cloudinary cloud name
    const uploadPreset = 'mypreset'; // Remplace avec ton preset
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);

      if (response.statusCode == 200) {
        return resJson['secure_url'];
      } else {
        Get.snackbar("Erreur Cloudinary", "Échec de l'upload : ${resJson['error']['message']}",
            backgroundColor: Colors.red, colorText: Colors.white);
        return null;
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur lors de l'upload : $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    String? uploadedImageUrl = imageUrl;

    if (selectedImage != null) {
      final imageUrlFromCloudinary = await _uploadImageToCloudinary(selectedImage!);
      if (imageUrlFromCloudinary == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      uploadedImageUrl = imageUrlFromCloudinary;
    }

    try {
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'nom': nomController.text.trim(),
        'prenom': prenomController.text.trim(),
        'telephone': telephoneController.text.trim(),
        'adresse': adrController.text.trim(),
        'ville': villeController.text.trim(),
        'preferences': preferenceController.text.trim(),
        'photoUrl': uploadedImageUrl,
      });

      Get.snackbar("Succès", "Informations mises à jour avec succès !",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.off(() =>  UserInfoPage());
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur est survenue : $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.secondary,
      appBar: AppBar(
        title: Text("Modifier mes infos", style: KTypography.h3(context, color: Colors.white)),
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
                          ? FileImage(selectedImage!)
                          : (imageUrl != null
                              ? NetworkImage(imageUrl!) as ImageProvider
                              : const AssetImage('assets/default_avatar.png')),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Iconsax.camera, color: KColors.primary, size: 18),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.user, "Nom", nomController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.user_tick, "Prénom", prenomController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.home, "Adresse", adrController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.location, "Ville", villeController),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.call, "Téléphone", telephoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField(Iconsax.setting_2, "Préférences", preferenceController),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: KColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _updateUserInfo,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
      validator: (value) => value == null || value.trim().isEmpty ? "Ce champ est requis" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: KColors.primary),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
