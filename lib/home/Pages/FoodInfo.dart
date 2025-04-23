import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../controller_pacontroll/PanierController.dart';
import '../../style.dart';
import 'package:provider/provider.dart';
class FoodInfo extends StatefulWidget {
  final Map<String, dynamic> plat;
  const FoodInfo({Key? key, required this.plat}) : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  dynamic quantity = 1; // Quantité sélectionnée
  List<String> selectedAccompaniments = []; // Accompagnements choisis

  @override
  Widget build(BuildContext context) {
    final panierController = Provider.of<PanierController>(context);
    final plat = widget.plat;

    return Scaffold(
      appBar: AppBar(
        title: Text(plat['nom'] ?? 'Détail du plat'),
        backgroundColor: KColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Image principale
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: plat['imageUrl'] != null && plat['imageUrl'].toString().startsWith('http')
                ? Image.network(
              plat['imageUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.asset(
              plat['imageUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Nom du plat
          Text(
            plat['nom'] ?? '',
            style: KTypography.h3(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 8),

          // Prix
          Text(
            'Prix: ${plat['prix']} FCFA',
            style: KTypography.h4(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            plat['desc'] ?? 'Pas de description disponible.',
            style: KTypography.h5(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 24),
          Text(
            plat['accompagnement'] ?? "Pas d'accompagnement disponible.",
            style: KTypography.h5(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 24),

          // Quantité
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantité', style: KTypography.h5(context, color: KColors.tertiary)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: KColors.primary),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text('$quantity', style: KTypography.h4(context, color: KColors.primary)),
                  IconButton(
                    icon: const Icon(Icons.add, color: KColors.primary),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bouton ajouter au panier
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                panierController.ajouterArticle(plat);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "${plat['nom']} ajouté à la commande"),
                    backgroundColor: KColors.primary,
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Ajouter",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: KColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}