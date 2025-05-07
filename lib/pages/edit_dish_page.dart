import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../style.dart';

class EditDishPage extends StatefulWidget {
  final Map<String, dynamic> dish;

  const EditDishPage({super.key, required this.dish});

  @override
  State<EditDishPage> createState() => _EditDishPageState();
}

class _EditDishPageState extends State<EditDishPage> {
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixController;

  String _selectedAccompagnement = 'Frites';
  String _selectedCategorie = 'Entrées';
  File? _selectedImage;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.dish['nom']);
    _descriptionController = TextEditingController(text: widget.dish['description']);
    _prixController = TextEditingController(text: widget.dish['prix'].toString());

    _selectedAccompagnement = widget.dish['accompagnements'] ?? 'Frites';
    _selectedCategorie = widget.dish['categorie'] ?? 'Entrées';
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _updateDish() async {
    try {
      // Envoi de la requête pour mettre à jour le plat via l'API
      FormData formData = FormData.fromMap({
        'nom': _nomController.text,
        'description': _descriptionController.text,
        'prix': double.tryParse(_prixController.text) ?? 0,
        'accompagnements': _selectedAccompagnement,
        'categorie': _selectedCategorie,
        // Si une nouvelle image est sélectionnée, l'inclure dans la requête
        if (_selectedImage != null) 'image': await MultipartFile.fromFile(_selectedImage!.path),
      });

      // Envoie de la requête HTTP PUT pour mettre à jour le plat
      Response response = await _dio.put(
        'https://ton-api.com/dishes/${widget.dish['id']}',
        data: formData,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Erreur lors de la mise à jour du plat : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur de mise à jour du plat : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Modifier le Plat', style: KTypography.h6(context, color: Colors.white)),
        backgroundColor: KColors.primary,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Modifier le Plat',
                  style: KTypography.h6(context, color: Colors.white),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom du plat',
                    labelStyle: KTypography.h5(context, color: KColors.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: KColors.tertiary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: KTypography.h5(context, color: KColors.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: KColors.tertiary,
                        width: 2,
                      ),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _prixController,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    labelStyle: KTypography.h5(context, color: KColors.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: KColors.tertiary,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedAccompagnement,
                        items: ['Frites', 'Riz', 'Salade']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedAccompagnement = val!),
                        decoration: InputDecoration(
                          labelText: 'Accompagnement',
                          labelStyle: KTypography.h5(context, color: KColors.tertiary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: KColors.tertiary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategorie,
                        items: ['Entrées', 'Plats', 'Desserts', 'Boissons']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedCategorie = val!),
                        decoration: InputDecoration(
                          labelText: 'Catégorie',
                          labelStyle: KTypography.h5(context, color: KColors.tertiary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: KColors.tertiary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Changer l’image'),
                    ),
                    const SizedBox(width: 16),
                    if (_selectedImage != null)
                      Image.file(_selectedImage!, width: 60, height: 60, fit: BoxFit.cover)
                    else if (widget.dish['imageUrl'] != '')
                      Image.network(widget.dish['imageUrl'],
                          width: 60, height: 60, fit: BoxFit.cover)
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateDish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Enregistrer les modifications',
                      style: KTypography.h6(context, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
