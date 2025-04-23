import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/style.dart';

class CommandeDetailsPage extends StatelessWidget {
  final DocumentSnapshot commande;

  CommandeDetailsPage({required this.commande});

  @override
  Widget build(BuildContext context) {
    final panier = commande['panier'] as List? ?? [];
    final totalPrice = panier.fold(0.0, (total, item) => total + (item['prix'] ?? 0.0));
    final dateCommande = commande['date_commande']?.toDate() ?? DateTime.now();
    final adresse = commande['adresse'] ?? 'Non spécifiée';
    final paiement = commande['paiement'] as Map<String, dynamic>? ?? {};

    final methodePaiement = paiement['methode']?.toString() ?? 'Non précisé';
    final detailsPaiement = (paiement['details'] as Map<String, dynamic>? ?? {});

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande', style: TextStyle(color: Colors.white)),
        backgroundColor: KColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Date de commande', dateCommande.toString()),
                    _buildInfoRow('Adresse', adresse),
                    _buildInfoRow('Mode de paiement', methodePaiement),
                    if (detailsPaiement.isNotEmpty)
                      _buildInfoRow('Détails paiement', detailsPaiement as String),
                  ],
                ),
              ),
            ),
            Text(
              'Plats commandés:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 8),
            ...panier.map((item) {
              final platNom = item['nom'] ?? 'Plat inconnu';
              final platPrix = item['prix'] ?? 0.0;
              final platImage = item['image'] ?? '';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          platImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: Icon(Icons.fastfood, color: KColors.primary),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              platNom,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${platPrix.toString()} FCFA',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            Card(
              margin: EdgeInsets.only(top: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prix total:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(0)} FCFA',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
