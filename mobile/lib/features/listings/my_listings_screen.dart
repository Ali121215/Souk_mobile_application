import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'listings_providers.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes annonces')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myListingsProvider.future),
        child: listingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Impossible de charger vos annonces.', style: const TextStyle(color: AppColors.clay)),
              ),
            ],
          ),
          data: (listings) {
            if (listings.isEmpty) {
              return ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Vous n'avez encore publie aucune annonce.", style: TextStyle(color: AppColors.muted)),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final listing = listings[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(listing.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(listing.prixAffiche, style: const TextStyle(color: AppColors.clay, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      _StatutBadge(statut: listing.statut),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    late final Color couleur;
    late final String texte;

    switch (statut) {
      case 'publiee':
        couleur = AppColors.green;
        texte = 'En ligne';
        break;
      case 'refusee':
        couleur = AppColors.clay;
        texte = 'Refusee';
        break;
      case 'vendue':
        couleur = AppColors.muted;
        texte = 'Vendue';
        break;
      default:
        couleur = AppColors.gold;
        texte = 'En attente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: couleur.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(texte, style: TextStyle(color: couleur, fontWeight: FontWeight.bold, fontSize: 11.5)),
    );
  }
}
