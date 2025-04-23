import 'package:flutter/material.dart';
import 'package:admin_plats_web/pages/addDishPage.dart';
import 'package:admin_plats_web/pages/admin_login_page.dart';
import 'package:admin_plats_web/pages/dishListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:admin_plats_web/theme/style.dart';
import 'package:admin_plats_web/pages/commandesPage.dart';
import 'package:admin_plats_web/pages/utilisateur_page.dart';
import 'package:admin_plats_web/pages/reservations_page.dart';

class AdminDashboard extends StatelessWidget {
  // Fonction pour récupérer le nombre d'utilisateurs
  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('user').get();
      return snapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération des utilisateurs : $e");
      return 0;
    }
  }

  // Fonction pour récupérer le nombre de commandes
  Future<int> getOrderCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('commandes').get();
      return snapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération des commandes : $e");
      return 0;
    }
  }

  // Fonction pour récupérer le nombre de plats
  Future<int> getDishCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dishes').get();
      return snapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération des plats : $e");
      return 0;
    }
  }

  // Fonction pour récupérer le nombre de réservations
  Future<int> getReservationCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reservations').get();
      return snapshot.size;
    } catch (e) {
      print("Erreur lors de la récupération des réservations : $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Plats Disponibles ',
        'value': FutureBuilder<int>(
          future: getDishCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur');
            } else {
              return Text(
                snapshot.data?.toString() ?? '0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.primary),
              );
            }
          },
        ),
        'page': DishListPage()
      },
      {
        'title': 'Commandes',
        'value': FutureBuilder<int>(
          future: getOrderCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur');
            } else {
              return Text(
                snapshot.data?.toString() ?? '0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.primary),
              );
            }
          },
        ),
        'page': Commandespage()
      },
      {
        'title': 'Utilisateurs',
        'value': FutureBuilder<int>(
          future: getUserCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur');
            } else {
              return Text(
                snapshot.data?.toString() ?? '0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.primary),
              );
            }
          },
        ),
        'page': UtilisateurPage()
      },
      {
        'title': 'Réservations',
        'value': FutureBuilder<int>(
          future: getReservationCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur');
            } else {
              return Text(
                snapshot.data?.toString() ?? '0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: KColors.primary),
              );
            }
          },
        ),
        'page': ReservationsPage()
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        backgroundColor: KColors.primary,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: KColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  'ADMIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list, color: KColors.tertiary),
              title: Text('Liste des plats', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DishListPage()),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: KColors.tertiary),
              title: Text('Ajouter un plat', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddDishPage()),
              ),
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: KColors.tertiary),
              title: Text('Déconnexion', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AdminLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: stats.map((item) {
            return _buildStatCard(
              context,
              item['title'] as String,
              item['value'] as Widget,
              item['page'] as Widget,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, Widget valueWidget, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              valueWidget,
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
