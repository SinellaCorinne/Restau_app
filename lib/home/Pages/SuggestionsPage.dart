import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/composants/CInput.dart';
import '../../style.dart'; // Assure-toi que KColors et KTypography sont définis dans ce fichier

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  // Variables pour les suggestions
  bool suggestion1 = false;
  bool suggestion2 = false;
  bool suggestion3 = false;
  bool suggestion4 = false;
  bool suggestion5 = false;
  bool suggestion6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggestions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Que pouvons-nous améliorer?",
              style: KTypography.h3(context, color: KColors.tertiary),
            ),
            SizedBox(height: 20),

            // Suggestion 1
            buildCheckboxOption(
              title: "Suggestion 1: Ajouter plus de produits",
              value: suggestion1,
              onChanged: (value) {
                setState(() {
                  suggestion1 = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // Suggestion 2
            buildCheckboxOption(
              title: "Suggestion 2: Améliorer l'interface",
              value: suggestion2,
              onChanged: (value) {
                setState(() {
                  suggestion2 = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // Suggestion 3
            buildCheckboxOption(
              title: "Suggestion 3: Ajouter un mode sombre",
              value: suggestion3,
              onChanged: (value) {
                setState(() {
                  suggestion3 = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // Suggestion 4
            buildCheckboxOption(
              title: "Suggestion 4: Ajouter plus de produits",
              value: suggestion4,
              onChanged: (value) {
                setState(() {
                  suggestion4 = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // Suggestion 5
            buildCheckboxOption(
              title: "Suggestion 5: Améliorer l'interface",
              value: suggestion5,
              onChanged: (value) {
                setState(() {
                  suggestion5 = value!;
                });
              },
            ),
            SizedBox(height: 10),

            // Suggestion 6
            buildCheckboxOption(
              title: "Suggestion 6: Ajouter un mode sombre",
              value: suggestion6,
              onChanged: (value) {
                setState(() {
                  suggestion6 = value!;
                });
              },
            ),
            SizedBox(height: 10,),
            Text("Autres",style: KTypography.h4(context, color: KColors.tertiary),),
            SizedBox(height: 5,),
            Cinput(name: "Ajouter d'autres suggestions......",
            ),

            SizedBox(height: 30),

            // Bouton "Enregistrer"
            ElevatedButton(
              onPressed: () {
                // Action pour enregistrer les suggestions
                print("Suggestions envoyées");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primary,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Soumettre ",
                style: KTypography.h6(context, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire une option de checkbox
  Widget buildCheckboxOption({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: KColors.tertiary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: KColors.tertiary,
            checkColor: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: KTypography.h6(context, color: KColors.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
