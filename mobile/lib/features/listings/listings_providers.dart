import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import 'data/listing.dart';
import 'data/listings_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final listingsRepositoryProvider = Provider<ListingsRepository>((ref) {
  return ListingsRepository(ref.watch(apiClientProvider));
});

/// Catégorie actuellement sélectionnée sur l'écran Accueil (null = toutes).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Ville actuellement sélectionnée (à terme, choisie à l'inscription / dans un sélecteur).
final selectedCityProvider = StateProvider<String>((ref) => "N'Djamena");

/// Recharge automatiquement dès que la ville ou la catégorie change.
final listingsProvider = FutureProvider.autoDispose<List<Listing>>((ref) async {
  final repository = ref.watch(listingsRepositoryProvider);
  final ville = ref.watch(selectedCityProvider);
  final categorie = ref.watch(selectedCategoryProvider);
  return repository.fetchListings(ville: ville, categorie: categorie);
});
