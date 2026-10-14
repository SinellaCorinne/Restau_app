import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/home/Pages/FoodInfo.dart';
import 'package:restau_app/mock/mock_data.dart';
import 'package:restau_app/style.dart';

class Accueilc extends StatefulWidget {
  const Accueilc({super.key});

  @override
  State<Accueilc> createState() => _AccueilcState();
}

class _AccueilcState extends State<Accueilc> {
  int currentPage = 0;
  String searchQuery = '';
  String selectedCategory = 'Tous';

  final List<String> images = [
    'assets/images/s_cocktail.jpeg',
    'assets/images/s_fraise.jpeg',
    'assets/images/s_pomme.jpeg',
    'assets/images/fastfoods.jpeg',
    'assets/images/plat1.jpeg',
    'assets/images/plat2.jpeg',
    'assets/images/plat3.jpeg',
  ];

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
    final plats = filteredDishes;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recherche
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Découvrez nos meilleurs plats",
                      style: KTypography.h3(context, color: KColors.tertiary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Trouvez un plat en particulier",
                      style: KTypography.h4(context, color: KColors.tertiary),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "Recherche...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),

              // Carousel de photos promotionnelles
              SizedBox(
                height: 160,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: KColors.primary.withOpacity(0.1),
                          child: Icon(Iconsax.gallery, color: KColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Indicateurs de pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: currentPage == index ? 12 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? KColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chips catégories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['Tous', 'Entrées', 'Plats', 'Desserts', 'Boissons']
                        .map((cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
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
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Grille de plats
              plats.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text("Aucun plat trouvé."),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: plats.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
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
                                    padding: const EdgeInsets.all(8.0),
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
