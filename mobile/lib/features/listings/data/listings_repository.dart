import '../../../core/network/api_client.dart';
import 'listing.dart';

class ListingsRepository {
  final ApiClient apiClient;
  ListingsRepository(this.apiClient);

  /// Appelle GET /api/v1/listings, avec filtres optionnels ville/catégorie.
  Future<List<Listing>> fetchListings({String? ville, String? categorie}) async {
    final response = await apiClient.dio.get('/listings', queryParameters: {
      if (ville != null) 'ville': ville,
      if (categorie != null) 'categorie': categorie,
    });

    final data = response.data as List<dynamic>;
    return data.map((json) => Listing.fromJson(json as Map<String, dynamic>)).toList();
  }
}
