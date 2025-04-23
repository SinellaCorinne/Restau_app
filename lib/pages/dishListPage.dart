import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:admin_plats_web/theme/style.dart';
import 'package:admin_plats_web/pages/edit_dish_page.dart';


class DishListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Liste des Plats'),
        backgroundColor:KColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('dishes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: KColors.primary,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Aucun plat disponible.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final dishes = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              final doc = dishes[index];
              final name = doc['nom'] as String? ?? '—';
              final price = (doc['prix'] as num?)?.toStringAsFixed(0) ?? '0';
              final imageUrl = doc['imageUrl'] as String? ?? '';

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(EditDishPage(dish: doc));
                    // TODO: Navigator.push vers EditDishPage(dishId: doc.id);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Vignette image ou icône
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),

                          child: imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 60,
                              height: 60,
                              color: KColors.tertiary,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: KColors.tertiary,
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          )
                              : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.fastfood,
                              color:KColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Infos du plat
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: KColors.tertiary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Prix : $price FCFA',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        // Actions
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: KColors.primary,
                              ),
                              onPressed: () {

                                // TODO: naviguer vers la page d'édition
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                // TODO: supprimer via Firestore
                                _confirmDelete(context, doc.id);
                              },
                            ),
                          ],
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

  void _confirmDelete(BuildContext context, String dishId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer ce plat?'),
        content: Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await _firestore.collection('dishes').doc(dishId).delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}


