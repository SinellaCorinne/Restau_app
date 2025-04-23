import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../theme/style.dart';
import 'commande_details_page.dart';

class Commandespage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Liste des Commandes'),
        backgroundColor: KColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('commandes')
            .orderBy('date_commande', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Aucune commande disponible.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final commandes = snapshot.data!.docs;

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

              final dateCommande = doc['date_commande']?.toDate() ?? DateTime.now();
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
                 //   Get.to(() => CommandeDetailsPage(commande: doc));
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
                         //   Get.to(() => CommandeDetailsPage(commande: doc));
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
