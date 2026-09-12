import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Liste des conversations de l'utilisateur.
/// TODO: brancher sur GET /api/v1/messages/conversation/:id
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Vos conversations avec les vendeurs et restaurants s\'afficheront ici.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      ),
    );
  }
}
