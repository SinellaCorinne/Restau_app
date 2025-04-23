import 'package:flutter/material.dart';
import '../style.dart'; // Assurez-vous que le chemin est correct

class Cinput extends StatelessWidget {
  final String? name;
  final TextInputType? keyboardType;
  final bool showClearButton;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final dynamic initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const Cinput({
    super.key,
    required this.name,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.initialValue,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder blackBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: KColors.tertiary, // Bordure noire
        width: 2,           // Épaisseur de la bordure
      ),
    );

    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      style: KTypography.h6(context),
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: name,
        labelStyle: KTypography.h5(context,color: KColors.tertiary,),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: blackBorder,
        enabledBorder: blackBorder, // Bordure quand le champ n’est pas focus
        focusedBorder: blackBorder, // Même bordure quand le champ est focus
        suffixIcon: showClearButton
            ? const Icon(Icons.close, size: 20, color: Colors.blue)
            : suffixIcon,
      ),
    );
  }
}
