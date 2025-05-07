import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../style.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final Dio _dio = Dio();
  late Future<List<Map<String, dynamic>>> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = _fetchReservations();
  }

  // Méthode pour récupérer les réservations depuis l'API
  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    try {
      final response = await _dio.get('https://ton-api.com/reservations');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> reservations =
        List<Map<String, dynamic>>.from(response.data);
        return reservations;
      } else {
        throw Exception('Erreur lors du chargement des réservations');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Liste des Réservations'),
        backgroundColor: KColors.primary, // Changer pour ta couleur principale
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune réservation trouvée.'));
          }

          var reservations = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservation = reservations[index];
              String name = reservation['name'] ?? 'Utilisateur inconnu';
              String date = reservation['date'] ?? 'Date inconnue';
              String time = reservation['time'] ?? 'Heure non trouvée';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Ajouter une action si tu veux ouvrir une page de détail de réservation
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Icône de réservation
                        Icon(
                          Icons.event_available,
                          color: KColors.primary, // Changer pour ta couleur principale
                          size: 40,
                        ),
                        SizedBox(width: 16),
                        // Informations de la réservation
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // Couleur texte principal
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Date: $date\nHeure: $time',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Actions (ici, on n'a pas de boutons, mais tu peux en ajouter)
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
