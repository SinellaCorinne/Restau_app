import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // Pour le format de date
import '../style.dart';

class CommandeDetailsPage extends StatelessWidget {
  final String commandeId; // L'ID de la commande que vous passez pour récupérer les détails

  CommandeDetailsPage({required this.commandeId});

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> _fetchCommandeDetails() async {
    try {
      final response = await _dio.get('https://your-api-url.com/commandes/$commandeId'); // Remplacez l'URL par celle de votre API
      if (response.statusCode == 200) {
        return response.data; // Assurez-vous que la réponse est un objet de commande
      } else {
        throw Exception('Erreur lors de la récupération des détails de la commande');
      }
    } catch (e) {
      print('Erreur: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande', style: TextStyle(color: Colors.white)),
        backgroundColor: KColors.primary,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchCommandeDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: KColors.primary,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Détails de la commande non disponibles.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final commande = snapshot.data!;
          final panier = commande['panier'] as List? ?? [];
          final totalPrice = panier.fold(0.0, (total, item) => total + (item['prix'] ?? 0.0));
          final dateCommande = DateTime.parse(commande['date_commande'] ?? DateTime.now().toString());
          final adresse = commande['adresse'] ?? 'Non spécifiée';
          final paiement = commande['paiement'] as Map<String, dynamic>? ?? {};

          final methodePaiement = paiement['methode']?.toString() ?? 'Non précisé';
          final detailsPaiement = paiement['details'];

          final dateFormatted = DateFormat('dd/MM/yyyy à HH:mm').format(dateCommande);

          return Padding(
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
                        _buildInfoRow('Date de commande', dateFormatted),
                        _buildInfoRow('Adresse', adresse),
                        _buildInfoRow('Mode de paiement', methodePaiement),
                        if (detailsPaiement is String && detailsPaiement.isNotEmpty)
                          _buildInfoRow('Détails paiement', detailsPaiement),
                        if (detailsPaiement is Map<String, dynamic>)
                          ...detailsPaiement.entries.map((entry) =>
                              _buildInfoRow(entry.key, entry.value.toString())),
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
          );
        },
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
