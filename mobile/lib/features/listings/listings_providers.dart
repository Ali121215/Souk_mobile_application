import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_providers.dart';
import 'data/listing.dart';
import 'data/listings_repository.dart';

export '../../core/network/api_providers.dart' show apiClientProvider;

final listingsRepositoryProvider = Provider<ListingsRepository>((ref) {
  return ListingsRepository(ref.watch(apiClientProvider));
});

/// CatÃ©gorie actuellement sÃ©lectionnÃ©e sur l'Ã©cran Accueil (null = toutes).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Ville actuellement sÃ©lectionnÃ©e (Ã  terme, choisie Ã  l'inscription / dans un sÃ©lecteur).
final selectedCityProvider = StateProvider<String>((ref) => "N'Djamena");

/// Recharge automatiquement dÃ¨s que la ville ou la catÃ©gorie change.
final listingsProvider = FutureProvider.autoDispose<List<Listing>>((ref) async {
  final repository = ref.watch(listingsRepositoryProvider);
  final ville = ref.watch(selectedCityProvider);
  final categorie = ref.watch(selectedCategoryProvider);
  return repository.fetchListings(ville: ville, categorie: categorie);
});

/// Charge le dÃ©tail d'une annonce prÃ©cise, Ã  la demande (un provider par id
/// grÃ¢ce Ã  `.family`), pour l'Ã©cran de dÃ©tail.
final listingDetailProvider = FutureProvider.autoDispose.family((ref, String id) {
  return ref.watch(listingsRepositoryProvider).fetchListingDetail(id);
});

final myListingsProvider = FutureProvider.autoDispose<List<Listing>>((ref) {
  return ref.watch(listingsRepositoryProvider).fetchMyListings();
});

