import 'package:flutter/material.dart';
import '../../style.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  int _numOfPeople = 2;
  String _selectedDate = '';
  String _selectedTime = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> availableTimes = ['12:00', '14:00', '18:00', '20:00'];

  Future<void> envoyerReservation(String name, String phone, String date,
      String time, int numOfPeople) async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 600));
    // Réservation enregistrée localement pour la démo
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
              value: _numOfPeople,
              items: [1, 2, 4, 6, 8].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value personnes'),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => _numOfPeople = newValue!),
              hint: const Text('Sélectionner le nombre de personnes'),
            ),
            const SizedBox(height: 20),

            // Sélection de la date
            TextField(
              controller: TextEditingController(text: _selectedDate),
              decoration: const InputDecoration(
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
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Sélection de l'heure
            DropdownButton<String>(
              value: _selectedTime.isEmpty ? null : _selectedTime,
              hint: const Text('Sélectionner l\'heure'),
              items: availableTimes.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (String? newTime) =>
                  setState(() => _selectedTime = newTime!),
            ),
            const SizedBox(height: 20),

            // Nom
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                icon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            const SizedBox(height: 20),

            // Téléphone
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                icon: const Icon(Icons.phone),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Bouton réserver
            ElevatedButton(
              onPressed: () async {
                if (_selectedDate.isNotEmpty &&
                    _selectedTime.isNotEmpty &&
                    _nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  await envoyerReservation(
                    _nameController.text,
                    _phoneController.text,
                    _selectedDate,
                    _selectedTime,
                    _numOfPeople,
                  );

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Confirmation de Réservation"),
                      content: Text(
                        "Votre réservation pour $_numOfPeople personnes le $_selectedDate à $_selectedTime est confirmée.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _numOfPeople = 2;
                              _selectedDate = '';
                              _selectedTime = '';
                              _nameController.clear();
                              _phoneController.clear();
                            });
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Veuillez remplir tous les champs.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: KColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Réserver la table"),
            ),
          ],
        ),
      ),
    );
  }
}
