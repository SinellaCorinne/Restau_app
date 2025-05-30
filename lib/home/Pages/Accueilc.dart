import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as query;
import 'package:iconsax/iconsax.dart';
import 'package:restau_app/composants/Header.dart';
import 'package:restau_app/home/Pages/FoodInfo.dart';
import 'package:restau_app/style.dart';
import '../../composants/CInput.dart';

class Accueilc extends StatefulWidget {
  const Accueilc({super.key});

  @override
  State<Accueilc> createState() => _AccueilcState();
}

class _AccueilcState extends State<Accueilc> {
  int currentPage = 0;
  String searchQuery = '';
  late Future<List<Map<String, dynamic>>> _dishesFuture;
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

  @override
  void initState() {
    super.initState();
    _dishesFuture = fetchDishesFromFirebase();
  }

  Future<List<Map<String, dynamic>>> fetchDishesFromFirebase() async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('dishes');

    if (selectedCategory != 'Tous') {
      query = query.where('categorie', isEqualTo: selectedCategory);
    }

    if (searchQuery.isNotEmpty) {
      query = query.where('nom', isGreaterThanOrEqualTo: searchQuery)
          .where('nom', isLessThanOrEqualTo: '$searchQuery\uf8ff');
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dishesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            }

            final plats = snapshot.data ?? [];

            return SingleChildScrollView(
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
                          onSubmitted: (value) {
                            setState(() {
                              searchQuery = value;
                              _dishesFuture = fetchDishesFromFirebase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Recherche...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),


                      ],
                    ),
                  ),

                  // Carrousel
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() => currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Indicateurs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        width: currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? KColors.primary
                              : KColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),

                  // Titre spécialités
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Nos spécialités",
                      style: KTypography.h3(context, color: KColors.tertiary),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cartes de plats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 0.88,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: plats.map((plat) {
                        return GestureDetector(
                          onTap: () => Get.to(FoodInfo(plat: plat)),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    plat['imageUrl'] ?? '',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(plat['nom'] ?? '',
                                          style: KTypography.h4(context)),
                                      Text("${plat['prix']} FCFA",
                                          style: KTypography.h4(context,
                                              color: KColors.primary)),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}