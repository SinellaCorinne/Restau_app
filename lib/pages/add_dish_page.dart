import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../components/c_input.dart';
import '../style.dart';

class AddDishPage extends StatefulWidget {
  @override
  _AddDishPageState createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();

  String _selectedAccompagnement = 'Frites';
  String _selectedCategorie = 'Entrées';

  Uint8List? _imageBytes;
  String? _imageName;

  final Dio _dio = Dio();
  final _cloudName = 'dmtutyn5e';
  final _uploadPreset = 'monpreset';

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
        _imageName = result.files.single.name;
      });
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_imageBytes == null) return null;

    final url = 'https://api.cloudinary.com/v1_1/$_cloudName/upload';
    final formData = FormData.fromMap({
      'upload_preset': _uploadPreset,
      'file': MultipartFile.fromBytes(_imageBytes!, filename: _imageName),
    });

    try {
      final response = await _dio.post(url, data: formData);
      return response.data['secure_url'];
    } catch (e) {
      print('Erreur Cloudinary: $e');
      return null;
    }
  }

  void _addDish() async {
    if (!_formKey.currentState!.validate()) return;

    final imageUrl = await _uploadToCloudinary();
    final data = {
      'nom': _nomController.text,
      'description': _descriptionController.text,
      'prix': double.tryParse(_prixController.text) ?? 0,
      'categorie': _selectedCategorie,
      'accompagnements': _selectedAccompagnement,
      'imageUrl': imageUrl ?? '',
    };

    try {
      // Remplace par l’URL de ton API backend
      final response = await _dio.post('https://your-api.com/dishes', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        print('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur d\'envoi du plat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ajouter un Plat'),
        backgroundColor: KColors.primary,
      ),
      body: Center(
        child: Container(
          width: 800,
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Ajouter un Plat',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 24),
                  Cinput(
                    controller: _nomController,
                    name: "Nom du Plat",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom du plat';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  Cinput(
                    controller: _prixController,
                    name: "Prix en FCFA",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le prix';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un nombre valide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedAccompagnement,
                          items: ['Frites', 'Riz', 'Salade']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedAccompagnement = v!),
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
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategorie,
                          items: ['Entrées', 'Plats', 'Desserts', 'Boisson']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedCategorie = v!),
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KColors.primary,
                        ),
                        child: Text('Choisir une image',
                            style: KTypography.h6(context, color: Colors.white)),
                      ),
                      SizedBox(width: 16),
                      if (_imageBytes != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _imageBytes!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addDish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Ajouter le plat',
                          style: KTypography.h6(context, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
