import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Liste des restaurants disponibles à la livraison dans la ville sélectionnée.
/// TODO: brancher sur GET /api/v1/restaurants?ville=...
class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Les restaurants de votre ville s\'afficheront ici.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      ),
    );
  }
}
