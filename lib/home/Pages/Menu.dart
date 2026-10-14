import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/mock/mock_data.dart';
import 'package:restau_app/style.dart';
import '../controller_pacontroll/PanierController.dart';
import 'FoodInfo.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final List<String> categories = ['Tous', 'Entrées', 'Plats', 'Desserts', 'Boissons'];
  String selectedCategory = 'Plats';
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredDishes {
    return mockDishes.where((plat) {
      final matchCategory =
          selectedCategory == 'Tous' || plat['categorie'] == selectedCategory;
      final matchSearch = searchQuery.isEmpty ||
          plat['nom'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final panierController = Provider.of<PanierController>(context);
    final plats = filteredDishes;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Rechercher un plat...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Chips de catégories
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      selectedColor: KColors.primary,
                      backgroundColor: Colors.white,
                      onSelected: (_) =>
                          setState(() => selectedCategory = cat),
                      labelStyle: TextStyle(
                        color: selectedCategory == cat
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Grille de plats
            Expanded(
              child: plats.isEmpty
                  ? const Center(child: Text("Aucun plat trouvé."))
                  : GridView.builder(
                      itemCount: plats.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final plat = plats[index];
                        return GestureDetector(
                          onTap: () => Get.to(FoodInfo(plat: plat)),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.asset(
                                    plat['imageUrl'],
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 100,
                                      color: KColors.primary.withOpacity(0.1),
                                      child: Icon(Iconsax.gallery,
                                          color: KColors.primary),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(plat['nom'],
                                          style: KTypography.h4(context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      Text(
                                        "${plat['prix']} FCFA",
                                        style: KTypography.h4(context,
                                            color: KColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(flex: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 0.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      panierController.ajouterArticle(plat);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${plat['nom']} ajouté à la commande"),
                                        backgroundColor: KColors.primary,
                                      ));
                                    },
                                    icon: const Icon(Icons.add,
                                        color: Colors.white),
                                    label: const Text("Ajouter",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: KColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
