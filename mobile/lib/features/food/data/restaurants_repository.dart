import '../../../core/network/api_client.dart';
import 'restaurant.dart';
import 'food_order.dart';

class RestaurantsRepository {
  final ApiClient apiClient;
  RestaurantsRepository(this.apiClient);

  Future<List<Restaurant>> fetchRestaurants({String? ville}) async {
    final response = await apiClient.dio.get('/restaurants', queryParameters: {
      if (ville != null) 'ville': ville,
    });
    final data = response.data as List<dynamic>;
    return data.map((json) => Restaurant.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<MenuItem>> fetchMenu(String restaurantId) async {
    final response = await apiClient.dio.get('/restaurants/$restaurantId/menu');
    final data = response.data as List<dynamic>;
    return data.map((json) => MenuItem.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> createOrder({
    required String restaurantId,
    required Map<String, int> panier,
    String? adresseLivraison,
  }) async {
    await apiClient.dio.post('/orders', data: {
      'restaurantId': restaurantId,
      'articles': panier.entries.map((e) => {'menuItemId': e.key, 'quantite': e.value}).toList(),
      if (adresseLivraison != null) 'adresseLivraison': adresseLivraison,
    });
  }

  Future<List<FoodOrder>> fetchMyOrders() async {
    final response = await apiClient.dio.get('/orders/mine');
    final data = response.data as List<dynamic>;
    return data.map((json) => FoodOrder.fromJson(json as Map<String, dynamic>)).toList();
  }
}
