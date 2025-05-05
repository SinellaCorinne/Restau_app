import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restau_app/composants/CInput.dart';
import 'package:restau_app/composants/ElevattedButton.dart';
import '../../style.dart';
import '../controller_pacontroll/PanierController.dart';

class Commande extends StatefulWidget {
  @override
  _CommandeState createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  String selectedPaymentMethod = 'Espèce';

  TextEditingController adresseController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? selectedDateTime;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController mobileNameController = TextEditingController();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  Future<void> envoyerCommande({
    required List<Map<String, dynamic>> panier,
    required String adresse,
    String? note,
    required DateTime heure,
    required String paiement,
    required Map<String, dynamic> paiementDetails,
  }) async {
    await Future.delayed(Duration(seconds: 1)); // Simulation traitement

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Commande confirmée"),
        content: Text("Votre commande a été validée avec succès via $paiement!"),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<PanierController>(context, listen: false).viderPanier();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    adresseController.dispose();
    noteController.dispose();
    mobileNumberController.dispose();
    mobileNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panierController = Provider.of<PanierController>(context);
    final panier = panierController.panier;
    final double totalPrix = panierController.getTotal();
    final double tva = totalPrix * 0.1;
    final double livraison = 1000;
    final double totalFinal = totalPrix + tva + livraison;

    return Scaffold(
      body: //panier.isEmpty
          //? const Center(child: Text("Votre panier est vide."))
         // : 
          ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...panier.map((item) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Image.asset(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item['nom']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['prix']} FCFA'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => panierController.supprimerArticle(panier.indexOf(item)),
                                ),
                                Text('${item['quantite'] ?? 1}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => panierController.incrementerQuantite(panier.indexOf(item)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => panierController.supprimerArticle(panier.indexOf(item)),
                        ),
                      ),
                    )),
                Text("Adresse de livraison :", style: KTypography.h4(context, color: KColors.tertiary)),
                Cinput(name: "Entrez votre adresse", controller: adresseController),
                const SizedBox(height: 12),
                Text("Remarques :", style: KTypography.h4(context, color: KColors.tertiary)),
                Cinput(name: "Ajouter une remarque", controller: noteController),
                const SizedBox(height: 12),
                Text("Heure de livraison :", style: KTypography.h4(context, color: KColors.tertiary)),
                const SizedBox(height: 8),
                Elevattedbutton(
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      selectedDateTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        picked.hour,
                        picked.minute,
                      );
                      setState(() {});
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choisir", style: KTypography.h6(context, color: Colors.white)),
                      if (selectedDateTime != null)
                        Text(
                          "Heure choisie : ${selectedDateTime!.hour.toString().padLeft(2, '0')}h${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.grey[200], fontSize: 12),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text("Sous-total : $totalPrix FCFA", style: KTypography.h5(context)),
                Text("TVA (10%) : $tva FCFA", style: KTypography.h5(context)),
                Text("Livraison : $livraison FCFA", style: KTypography.h5(context)),
                const Divider(),
                Text("Total : ${totalFinal.toStringAsFixed(3)} FCFA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                Text("Mode de paiement :", style: KTypography.h4(context, color: KColors.tertiary)),
                ...['Espèce', 'Mobile Money', 'Carte bancaire'].map((method) {
                  return ListTile(
                    title: Text(method),
                    leading: Checkbox(
                      activeColor: KColors.tertiary,
                      value: selectedPaymentMethod == method,
                      onChanged: (value) {
                        if (value == true) setState(() => selectedPaymentMethod = method);
                      },
                    ),
                  );
                }),
                if (selectedPaymentMethod == 'Mobile Money') ...[
                  Cinput(name: "Numéro de téléphone", controller: mobileNumberController),
                  SizedBox(height: 10),
                  Cinput(name: "Nom inscrit sur le numéro", controller: mobileNameController),
                ],
                if (selectedPaymentMethod == 'Carte bancaire') ...[
                  Cinput(name: "Numéro de carte", controller: cardNumberController),
                  SizedBox(height: 10),
                  Cinput(name: "Date d'expiration", controller: expiryDateController),
                  SizedBox(height: 10),
                  Cinput(name: "CVV (Card Verification Value) ", controller: cvvController),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final adresse = adresseController.text.trim();
                    if (adresse.isEmpty || selectedDateTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Adresse et heure obligatoires.")));
                      return;
                    }

                    Map<String, dynamic> paiementDetails = {};
                    if (selectedPaymentMethod == 'Mobile Money') {
                      paiementDetails = {
                        'numero': mobileNumberController.text.trim(),
                        'nom': mobileNameController.text.trim(),
                      };
                    } else if (selectedPaymentMethod == 'Carte bancaire') {
                      paiementDetails = {
                        'carte': cardNumberController.text.trim(),
                        'expiration': expiryDateController.text.trim(),
                        'cvv': cvvController.text.trim(),
                      };
                    }

                    await envoyerCommande(
                      panier: panier,
                      adresse: adresse,
                      note: noteController.text,
                      heure: selectedDateTime!,
                      paiement: selectedPaymentMethod,
                      paiementDetails: paiementDetails,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Valider la commande", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
    );
  }
}
