import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_providers.dart';
import '../listings/listings_providers.dart' show selectedCityProvider;
import 'data/restaurant.dart';
import 'data/restaurants_repository.dart';

final restaurantsRepositoryProvider = Provider<RestaurantsRepository>((ref) {
  return RestaurantsRepository(ref.watch(apiClientProvider));
});

final restaurantsProvider = FutureProvider.autoDispose<List<Restaurant>>((ref) {
  final ville = ref.watch(selectedCityProvider);
  return ref.watch(restaurantsRepositoryProvider).fetchRestaurants(ville: ville);
});

final menuProvider = FutureProvider.autoDispose.family<List<MenuItem>, String>((ref, restaurantId) {
  return ref.watch(restaurantsRepositoryProvider).fetchMenu(restaurantId);
});

final cartRestaurantIdProvider = StateProvider<String?>((ref) => null);

class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  void add(String menuItemId) {
    state = {...state, menuItemId: (state[menuItemId] ?? 0) + 1};
  }

  void changeQuantity(String menuItemId, int delta) {
    final current = (state[menuItemId] ?? 0) + delta;
    final next = {...state};
    if (current <= 0) {
      next.remove(menuItemId);
    } else {
      next[menuItemId] = current;
    }
    state = next;
  }

  void clear() {
    state = {};
  }

  int get totalArticles => state.values.fold(0, (a, b) => a + b);
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>((ref) => CartNotifier());

int cartSubtotal(Map<String, int> panier, List<MenuItem> menu) {
  int total = 0;
  for (final entry in panier.entries) {
    final item = menu.where((m) => m.id == entry.key).firstOrNull;
    if (item != null) total += item.prixFcfa * entry.value;
  }
  return total;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

final myOrdersProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(restaurantsRepositoryProvider).fetchMyOrders();
});
