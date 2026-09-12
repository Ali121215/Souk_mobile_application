import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'listings_providers.dart';
import 'widgets/listing_card.dart';

/// Catégories affichées à l'écran, mappées vers les valeurs attendues par l'API.
const _categories = <String, String>{
  'Immobilier': 'immobilier',
  'Véhicules': 'vehicules',
  'Matériel': 'materiel',
  'Électronique': 'electronique',
  'Mode': 'mode',
  'Services': 'services',
};

/// Écran d'accueil : catégories d'annonces + annonces récentes, branché sur
/// GET /api/v1/listings via [listingsProvider].
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(listingsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(listingsProvider.future),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = _categories.keys.elementAt(index);
                  final value = _categories.values.elementAt(index);
                  final isSelected = selectedCategory == value;
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedCategoryProvider.notifier).state =
                          isSelected ? null : value;
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text('Annonces récentes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            listingsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Impossible de charger les annonces. Vérifiez que le backend tourne "
                  "et que l'adresse API est correcte.\n\nDétail : $error",
                  style: const TextStyle(color: AppColors.clay),
                ),
              ),
              data: (listings) {
                if (listings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Aucune annonce publiée pour cette ville/catégorie pour le moment.",
                      style: TextStyle(color: AppColors.muted),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: listings.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) => ListingCard(listing: listings[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
