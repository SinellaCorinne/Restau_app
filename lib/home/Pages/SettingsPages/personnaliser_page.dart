import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../style.dart';

class PersonnaliserPage extends StatefulWidget {
  @override
  _PersonnaliserPageState createState() => _PersonnaliserPageState();
}

class _PersonnaliserPageState extends State<PersonnaliserPage> {
  bool isDarkMode = false;
  String selectedLanguage = 'Français';
  double fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          isDarkMode = data['theme'] == 'dark';
          selectedLanguage = data['language'] ?? 'Français';
          fontSize = (data['fontSize'] ?? 16.0).toDouble();
        });
      }
    }
  }

  Future<void> savePreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'theme': isDarkMode ? 'dark' : 'light',
        'language': selectedLanguage,
        'fontSize': fontSize,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Préférences enregistrées !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnaliser', style: KTypography.h3(context, color: Colors.white)),
        backgroundColor: KColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apparence', style: KTypography.h5(context, color: KColors.primary)),
            SizedBox(height: 10),

            // Mode sombre
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: KColors.secondary, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: SwitchListTile(
                title: Text('Mode sombre', style: KTypography.h5(context)),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeColor: KColors.primary,
              ),
            ),

            SizedBox(height: 20),
            Text('Langue', style: KTypography.h5(context, color: KColors.primary)),
            SizedBox(height: 10),

            // Langue
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: KColors.secondary, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    items: ['Français', 'English', 'Español', 'Deutsch'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: KTypography.h5(context)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text('Taille du texte', style: KTypography.h5(context, color: KColors.primary)),
            SizedBox(height: 10),

            // Taille du texte
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: KColors.secondary, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exemple de texte',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                    ),
                    Slider(
                      value: fontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 6,
                      activeColor: KColors.tertiary,
                      inactiveColor: KColors.tertiary.withOpacity(0.2),
                      label: fontSize.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          fontSize = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // 🔘 Bouton enregistrer
            Center(
              child: ElevatedButton.icon(
                onPressed: savePreferences,
                icon: Icon(Icons.save),
                label: Text('Enregistrer les préférences'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
