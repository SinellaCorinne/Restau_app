import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Français';
  double _fontSize = 16.0;

  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  double get fontSize => _fontSize;

  PreferencesProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        _isDarkMode = data['theme'] == 'dark';
        _selectedLanguage = data['language'] ?? 'Français';
        _fontSize = (data['fontSize'] ?? 16.0).toDouble();
        notifyListeners();
      }
    }
  }

  Future<void> savePreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'theme': _isDarkMode ? 'dark' : 'light',
        'language': _selectedLanguage,
        'fontSize': _fontSize,
      });
    }
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void changeLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void changeFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
}
