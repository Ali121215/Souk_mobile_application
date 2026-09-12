import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Offres d'emploi par ville et secteur.
/// TODO: brancher sur GET /api/v1/jobs?ville=...&secteur=...
/// Note : accessible pour l'instant depuis une tuile "Emploi" en Accueil.
/// À décider ensemble : lui donner son propre onglet dans la barre de navigation
/// une fois qu'on aura testé l'usage réel avec les premiers utilisateurs.
class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emploi')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Les offres d\'emploi de votre ville s\'afficheront ici.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      ),
    );
  }
}
