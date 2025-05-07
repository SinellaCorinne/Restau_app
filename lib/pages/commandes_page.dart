import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../style.dart';
import 'commande_details_page.dart';

class Commandespage extends StatelessWidget {
  final Dio _dio = Dio();

  Future<List<dynamic>> _fetchCommandes() async {
    try {
      final response = await _dio.get('https://your-api-url.com/commandes'); // Remplacez l'URL par votre propre API
      if (response.statusCode == 200) {
        return response.data; // Assurez-vous que la réponse est une liste de commandes
      } else {
        throw Exception('Erreur de chargement des commandes');
      }
    } catch (e) {
      print('Erreur: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Liste des Commandes'),
        backgroundColor: KColors.primary,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchCommandes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucune commande disponible.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final commandes = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: commandes.length,
            itemBuilder: (context, index) {
              final doc = commandes[index];
              final panier = doc['panier'] as List<dynamic>? ?? [];

              final totalPrice = panier.fold(0.0, (total, item) {
                try {
                  final prix = item['prix'];
                  if (prix is num) {
                    return total + prix.toDouble();
                  } else if (prix is String) {
                    final cleaned = prix.replaceAll(RegExp(r'[^\d.]'), '');
                    final parsed = double.tryParse(cleaned);
                    return total + (parsed ?? 0.0);
                  } else {
                    debugPrint('⚠️ Prix invalide: $prix');
                    return total;
                  }
                } catch (e) {
                  debugPrint('❌ Erreur lors du calcul du prix: $e');
                  return total;
                }
              });

              final dateCommande = doc['date_commande'] ?? DateTime.now();
              final adresse = doc['adresse'] ?? 'Non spécifiée';

              final paiement = doc['paiement'];
              String methodePaiement = 'Non précisé';

              if (paiement is Map<String, dynamic> && paiement['methode'] != null) {
                methodePaiement = paiement['methode'].toString();
              }

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Naviguer vers la page de détails de la commande
                    Get.to(() => CommandeDetailsPage( commandeId: '',));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.fastfood,
                              color: KColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commande ${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: KColors.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Prix total: ${totalPrice.toStringAsFixed(0)} FCFA',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Adresse: $adresse',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Paiement: $methodePaiement',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: KColors.primary,
                          ),
                          onPressed: () {
                            // Naviguer vers la page de détails de la commande
                            Get.to(() => CommandeDetailsPage( commandeId: '',));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
