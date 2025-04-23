import 'package:flutter/material.dart';
class PanierController extends ChangeNotifier {
  List<Map<String, dynamic>> _panier = [];

  List<Map<String, dynamic>> get panier => _panier;

  void ajouterArticle(Map<String, dynamic> article) {
    _panier.add(article);

  }

  void supprimerArticle(int index) {
    _panier.removeAt(index);

  }

  void viderPanier() {
    _panier.clear();

  }
  // Méthode pour obtenir le total du panier

  double getTotal() {
    double total = 0;
    for (var item in _panier) {
      total += double.tryParse((item['prix'] ?? '0').toString().replaceAll(' FCFA', '')) ?? 0;
    }
    return double.parse(total.toStringAsFixed(3)); // Formate le total à trois décimales
  }


  void incrementerQuantite(int index) {
    // Vérifier si la quantité est présente dans l'article du panier
    if (_panier[index]['quantite'] != null) {
      // Convertir la quantité actuelle en entier, l'incrémenter, puis la remettre dans le panier
      int currentQuantity = int.tryParse(_panier[index]['quantite'] ?? '1') ?? 1;
      currentQuantity++;
      _panier[index]['quantite'] = currentQuantity.toString();
    } else {
      // Si aucune quantité n'est spécifiée, initialiser à 1
      _panier[index]['quantite'] = '1';
    }


} }