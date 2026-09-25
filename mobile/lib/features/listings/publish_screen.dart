import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_providers.dart';
import '../auth/login_screen.dart';
import 'listings_providers.dart';

const _categories = <String, String>{
  'Immobilier': 'immobilier',
  'Véhicules': 'vehicules',
  'Matériel': 'materiel',
  'Électronique': 'electronique',
  'Mode': 'mode',
  'Services': 'services',
};

/// Formulaire de dépôt d'annonce, branché sur POST /api/v1/listings.
/// Exige d'être connecté — sinon on propose de se connecter d'abord, comme sur Avito.
class PublishScreen extends ConsumerStatefulWidget {
  const PublishScreen({super.key});

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  final _titreController = TextEditingController();
  final _prixController = TextEditingController();
  String _categorie = _categories.values.first;
  bool _loading = false;
  String? _error;
  bool _success = false;

  Future<void> _submit() async {
    final isLoggedIn = ref.read(isLoggedInProvider);

    if (!isLoggedIn) {
      final loggedIn = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (loggedIn != true) return; // l'utilisateur a annulé la connexion
    }

    if (_titreController.text.trim().isEmpty || _prixController.text.trim().isEmpty) {
      setState(() => _error = 'Merci de remplir le titre et le prix.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ville = ref.read(selectedCityProvider);
      await ref.read(listingsRepositoryProvider).createListing(
            titre: _titreController.text.trim(),
            categorie: _categorie,
            prixFcfa: int.parse(_prixController.text.trim()),
            ville: ville,
          );
      setState(() => _success = true);
      _titreController.clear();
      _prixController.clear();
    } catch (e) {
      setState(() => _error = "Erreur lors de la publication. Vérifiez votre connexion.");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Publier une annonce', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            "Elle sera visible après vérification par notre équipe (comme sur Avito).",
            style: TextStyle(color: AppColors.muted, fontSize: 12.5),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titreController,
            decoration: const InputDecoration(labelText: 'Titre de l\'annonce', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _categorie,
            decoration: const InputDecoration(labelText: 'Catégorie', border: OutlineInputBorder()),
            items: _categories.entries
                .map((entry) => DropdownMenuItem(value: entry.value, child: Text(entry.key)))
                .toList(),
            onChanged: (value) => setState(() => _categorie = value!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prixController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Prix (FCFA)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Publier l\'annonce'),
          ),
          if (_success) ...[
            const SizedBox(height: 12),
            const Text('Annonce envoyée ! Elle apparaîtra après modération.', style: TextStyle(color: AppColors.green)),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.clay)),
          ],
        ],
      ),
    );
  }
}
