import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/style.dart';

class UtilisateurPage extends StatefulWidget {
  const UtilisateurPage({super.key});

  @override
  State<UtilisateurPage> createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends State<UtilisateurPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Liste des utilisateurs'),
        backgroundColor: KColors.primary, // Changer pour ta couleur principale
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          }

          // Récupérer les documents de la collection 'user'
          var users = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              String lastName = user['nom'] ?? 'Nom inconnu';
              String firstName = user['prenom'] ?? 'Prénom inconnu';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Ajouter une action pour ouvrir une page de détail utilisateur
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Icône de l'utilisateur
                        Icon(
                          Icons.person,
                          color: Colors.blueAccent, // Changer pour ta couleur principale
                          size: 40,
                        ),
                        SizedBox(width: 16),
                        // Informations de l'utilisateur
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$firstName $lastName',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // Couleur texte principal
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Prénom : $firstName\nNom : $lastName',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Actions (ici, tu peux ajouter des boutons pour chaque utilisateur)
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
