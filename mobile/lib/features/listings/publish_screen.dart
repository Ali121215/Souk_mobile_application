import 'package:flutter/material.dart';

/// Formulaire de dépôt d'annonce.
/// TODO: brancher sur POST /api/v1/listings et l'upload de photos vers le stockage médias.
class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final _titreController = TextEditingController();
  final _prixController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Publier une annonce', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _titreController,
            decoration: const InputDecoration(labelText: 'Titre de l\'annonce', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prixController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Prix (FCFA)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: appeler ListingsRepository.create(...)
            },
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text('Publier l\'annonce'),
            ),
          ),
        ],
      ),
    );
  }
}
