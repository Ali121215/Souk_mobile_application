import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Écran d'accueil : catégories d'annonces + annonces récentes.
/// Pour l'instant un squelette statique — à brancher sur ListingsRepository (API /listings).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const categories = [
    'Immobilier', 'Véhicules', 'Matériel', 'Électronique', 'Mode', 'Services',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => Chip(
                label: Text(categories[index]),
                backgroundColor: index == 0 ? AppColors.primary : AppColors.surface,
                labelStyle: TextStyle(
                  color: index == 0 ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text('Annonces récentes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          // TODO: remplacer par un GridView alimenté par GET /api/v1/listings?ville=...
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Aucune annonce chargée pour le moment.', style: TextStyle(color: AppColors.muted)),
          ),
        ],
      ),
    );
  }
}
