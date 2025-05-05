import 'package:flutter/material.dart';

import '../../../style.dart';


class ConfidentialitePage extends StatefulWidget {
  @override
  _ConfidentialitePageState createState() => _ConfidentialitePageState();
}

class _ConfidentialitePageState extends State<ConfidentialitePage> {
  bool partageLocalisation = true;
  bool analyticsData = true;
  bool publicitesCiblees = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidentialité', style: KTypography.h3(context,color: Colors.white)),
        backgroundColor: KColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paramètres de confidentialité',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            _buildSwitchTile(
              'Partage de localisation',
              'Permet de partager votre localisation pour améliorer les services',
              partageLocalisation,
                  (value) {
                setState(() {
                  partageLocalisation = value;
                });
              },
            ),

            SizedBox(height: 8),
            _buildSwitchTile(
              'Collecte de données d\'analyse',
              'Aide à améliorer l\'application en partageant des données anonymes d\'utilisation',
              analyticsData,
                  (value) {
                setState(() {
                  analyticsData = value;
                });
              },
            ),

            SizedBox(height: 8),
            _buildSwitchTile(
              'Publicités ciblées',
              'Permet d\'afficher des publicités personnalisées selon vos centres d\'intérêt',
              publicitesCiblees,
                  (value) {
                setState(() {
                  publicitesCiblees = value;
                });
              },
            ),

            SizedBox(height: 20),
            Text(
              'Gestion des données',
              style: KTypography.h5(context, color: KColors.primary),
            ),
            SizedBox(height: 10),

            _buildActionTile(
              'Télécharger mes données',
              'Récupérez une copie de vos données personnelles',
              Icons.download,
                  () {
                // Logique pour télécharger les données
              },
            ),

            SizedBox(height: 8),
            _buildActionTile(
              'Supprimer mes données',
              'Supprimez définitivement toutes vos données personnelles',
              Icons.delete_outline,
                  () {
                _showDeleteConfirmation(context);
              },
              color: Colors.redAccent,
            ),

            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: KColors.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information',
                    style: KTypography.h5(context, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nous nous engageons à protéger vos données personnelles. Pour plus d\'informations, consultez notre politique de confidentialité.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: KColors.secondary,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(title, style: KTypography.h5(context)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        value: value,
        onChanged: onChanged,

        activeColor: KColors.primary,
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap, {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: KColors.secondary,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? KColors.primary),
        title: Text(title, style: KTypography.h5(context)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer mes données ?'),
          content: Text('Cette action est irréversible et effacera définitivement toutes vos données personnelles.'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Logique pour supprimer les données
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}