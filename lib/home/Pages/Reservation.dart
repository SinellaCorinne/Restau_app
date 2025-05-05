import 'package:flutter/material.dart';
import '../../style.dart';
import 'package:dio/dio.dart' as dio_package;


class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final dio_package.Dio dio = dio_package.Dio();
  int numOfPeople = 2;
  String _selectedDate = '';
  String _selectedTime = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Liste des horaires disponibles
  List<String> availableTimes = ['12:00', '14:00', '18:00', '20:00'];

Future<void> envoyerReservation(String name, String phone, String date, String time, int numOfPeople) async {
  
  try {
    // Créer un document avec les informations de la réservation
     dio_package.Response response ;await dio.post(
    
     'https://httpbin.org/post',// url à remplacer 
        data: {
          "name":nameController.text,
          "phone":phoneController.text,
          "time": time,
          "date": date,
          "numofPeople":numOfPeople
        },
    );

    // Afficher un message de succès
    print('Réservation ajoutée avec succès.');
  } catch (e) {
    print('Erreur lors de l\'ajout de la réservation : $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nombre de personnes
            DropdownButton<int>(
              value: numOfPeople,
              items: [1, 2, 4, 6, 8].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value personnes'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  numOfPeople = newValue!;
                });
              },
              hint: Text('Sélectionner le nombre de personnes'),
            ),
            const SizedBox(height: 20),

            // Sélection de la date
            TextField(
              controller: TextEditingController(text: _selectedDate),
              decoration: InputDecoration(
                labelText: 'Sélectionner la date',
                icon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != DateTime.now()) {
                  setState(() {
                    _selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Sélection de l'heure
            DropdownButton<String>(
              value: _selectedTime.isEmpty ? null : _selectedTime,
              hint: Text('Sélectionner l\'heure'),
              items: availableTimes.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (String? newTime) {
                setState(() {
                  _selectedTime = newTime!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Informations utilisateur
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                icon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                icon: Icon(Icons.phone),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Bouton de réservation
            ElevatedButton(
  onPressed: () async {
    if (_selectedDate.isNotEmpty && _selectedTime.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      // Appeler la fonction pour envoyer la réservation
      await envoyerReservation(
        nameController.text,
        phoneController.text,
        _selectedDate,
        _selectedTime,
        numOfPeople,
      );

      // Afficher un message de confirmation
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Confirmation de Réservation"),
          content: Text(
              "Votre réservation pour $numOfPeople personnes le $_selectedDate à $_selectedTime est confirmée."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Réinitialiser les champs après confirmation
                setState(() {
                  numOfPeople = 2;
                  _selectedDate = '';
                  _selectedTime = '';
                  nameController.clear();
                  phoneController.clear();
                });
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
    }
  },
  child: Text("Réserver la table"),
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: KColors.primary,
    padding: EdgeInsets.symmetric(vertical: 15),
  ),
),

          ],
        ),
      ),
    );
  }
}
