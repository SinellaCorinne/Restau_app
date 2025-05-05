import 'package:flutter/material.dart';

import '../style.dart';
// Assurez-vous que le chemin est correct

class CListTile extends StatelessWidget {
  final String title;

  final IconData icon;

  CListTile({
    super.key,
    required this.title,

     required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, // Utilisez une couleur secondaire avec opacité
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: KColors.tertiary,)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         SizedBox(width: 35,child: Icon(icon),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: KTypography.h5(context, color: Colors.black), // Utilisez le style de texte défini
              ),

            ],
          ),
        ],
      ),
    );
  }
}
