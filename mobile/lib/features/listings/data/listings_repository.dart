import '../../../core/network/api_client.dart';
import 'listing.dart';
import 'listing_detail.dart';

class ListingsRepository {
  final ApiClient apiClient;
  ListingsRepository(this.apiClient);

  /// Appelle GET /api/v1/listings, avec filtres optionnels ville/catÃ©gorie.
  Future<List<Listing>> fetchListings({String? ville, String? categorie}) async {
    final response = await apiClient.dio.get('/listings', queryParameters: {
      if (ville != null) 'ville': ville,
      if (categorie != null) 'categorie': categorie,
    });

    final data = response.data as List<dynamic>;
    return data.map((json) => Listing.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Appelle GET /api/v1/listings/:id â€” inclut le contact du vendeur.
  Future<ListingDetail> fetchListingDetail(String id) async {
    final response = await apiClient.dio.get('/listings/$id');
    return ListingDetail.fromJson(response.data as Map<String, dynamic>);
  }


  Future<List<Listing>> fetchMyListings() async {
    final response = await apiClient.dio.get('/listings/mine/liste');
    final data = response.data as List<dynamic>;
    return data.map((json) => Listing.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Appelle POST /api/v1/listings â€” nÃ©cessite d'Ãªtre connectÃ© (le token est
  /// ajoutÃ© automatiquement par apiClientProvider). L'annonce part en
  /// modÃ©ration cÃ´tÃ© serveur, elle n'apparaÃ®tra pas tout de suite dans la liste.
  Future<void> createListing({
    required String titre,
    required String categorie,
    required int prixFcfa,
    required String ville,
  }) async {
    await apiClient.dio.post('/listings', data: {
      'titre': titre,
      'categorie': categorie,
      'prixFcfa': prixFcfa,
      'ville': ville,
    });
  }
}

