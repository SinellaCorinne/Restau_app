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
  
  @override
  Widget build(BuildContext context) {
    final panierController = Provider.of<PanierController>(context);
    final plat = widget.plat;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details du plat"),
        backgroundColor: KColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Image principale
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:  Image.asset( 'assets/images/shenggeng.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Nom du plat
          Text(
            "Rafraichissement",
            style: KTypography.h3(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 8),

          // Prix
          Text(
            'Prix: 2500 FCFA',
            style: KTypography.h4(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 16),

          // Description
          Text("Disponible immediatement",
            style: KTypography.h5(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 24),
          Text(
             "Pas d'accompagnement disponible.",
            style: KTypography.h5(context, color: KColors.tertiary),
          ),
          const SizedBox(height: 24),

          // Quantité
        
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