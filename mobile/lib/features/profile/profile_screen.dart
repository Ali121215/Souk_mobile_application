import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Profil utilisateur : ses annonces, ses commandes, ses candidatures, paramètres.
/// TODO: brancher sur l'utilisateur authentifié (état global via Riverpod).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: AppColors.gold, child: Text('D')),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mon compte', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text('+235 66 XX XX XX', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _ProfileRow(label: 'Mes annonces'),
          _ProfileRow(label: 'Mes commandes repas'),
          _ProfileRow(label: 'Mes candidatures emploi'),
          _ProfileRow(label: 'Favoris'),
          _ProfileRow(label: 'Moyens de paiement'),
          _ProfileRow(label: 'Paramètres'),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  const _ProfileRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      onTap: () {},
    );
  }
}
