import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:admin_plats_web/theme/style.dart';
import 'package:admin_plats_web/composant/Cinput.dart';
import 'package:admin_plats_web/composant/elevattedbutton.dart';

class AddDishPage extends StatefulWidget {
  @override
  _AddDishPageState createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedAccompagnement = 'Frites';
  String _selectedCategorie = 'Entrées';

  Uint8List? _imageBytes;
  String? _imageName;

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
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          _imageBytes!,
          filename: _imageName,
        ),
      );

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = json.decode(await response.stream.bytesToString());
      return body['secure_url'] as String?;
    } else {
      print('Erreur Cloudinary: ${response.statusCode}');
      return null;
    }
  }

  void _addDish() async {
    if (!_formKey.currentState!.validate()) return;

    final imageUrl = await _uploadToCloudinary();
    try {
      await _firestore.collection('dishes').add({
        'nom': _nomController.text,
        'description': _descriptionController.text,
        'prix': double.tryParse(_prixController.text) ?? 0,
        'categorie': _selectedCategorie,
        'accompagnements': _selectedAccompagnement,
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context);

    } catch (e) {
      print('Erreur d\'ajout de plat: $e');
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
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
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
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
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
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
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
                        child: Text('Choisir une image',style: KTypography.h6(context,color: Colors.white)),
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
                      child: Text('Ajouter le plat',style: KTypography.h6(context,color: Colors.white)),
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
