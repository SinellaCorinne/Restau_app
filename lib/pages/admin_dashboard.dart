import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:web_app/pages/reservations_page.dart';
import 'package:web_app/pages/utilisateur_page.dart';
import '../style.dart';
import 'add_dish_page.dart';
import 'admin_login.dart';
import 'commandes_page.dart';
import 'dish_list_page.dart';

class AdminDashboard extends StatelessWidget {
  final Dio dio = Dio();

  Future<int> fetchCount(String endpoint) async {
    try {
      final response = await dio.get('https://your-api-url.com/$endpoint');
      return response.data['count'] ?? 0;
    } catch (e) {
      print("Erreur lors de la récupération de $endpoint : $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Plats Disponibles',
        'endpoint': 'dishes/count',
        'page': DishListPage()
      },
      {
        'title': 'Commandes',
        'endpoint': 'commandes/count',
        'page': Commandespage()
      },
      {
        'title': 'Utilisateurs',
        'endpoint': 'users/count',
        'page': UtilisateurPage()
      },
      {
        'title': 'Réservations',
        'endpoint': 'reservations/count',
        'page': ReservationsPage()
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard Admin',style: KTypography.h3(context,color: Colors.white),),
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
                child: Text('ADMIN', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list, color: KColors.tertiary),
              title: Text('Liste des plats', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DishListPage())),
            ),
            ListTile(
              leading: Icon(Icons.add, color: KColors.tertiary),
              title: Text('Ajouter un plat', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddDishPage())),
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: KColors.tertiary),
              title: Text('Déconnexion', style: KTypography.h5(context, color: KColors.tertiary)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminLogin()));
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
              fetchCount(item['endpoint'] as String),
              item['page'] as Widget,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, Future<int> future, Widget targetPage) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<int>(
                future: future,
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
