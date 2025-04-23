class Plat {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final String accompagnement;
  final String categorie;
  final String imageUrl;

  Plat({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.accompagnement,
    required this.categorie,
    required this.imageUrl,
  });

  factory Plat.fromMap(String id, Map<String, dynamic> data) {
    return Plat(
      id: id,
      nom: data['nom'],
      description: data['description'],
      prix: data['prix'],
      accompagnement: data['accompagnement'],
      categorie: data['categorie'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'prix': prix,
      'accompagnement': accompagnement,
      'categorie': categorie,
      'imageUrl': imageUrl,
    };
  }
}
