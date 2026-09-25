import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import '../../features/auth/auth_providers.dart';

/// Le client API est reconstruit avec le bon header "Authorization" dès que
/// le token de connexion change (connexion, déconnexion, token restauré au démarrage).
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  final token = ref.watch(authTokenProvider).valueOrNull;

  if (token != null) {
    client.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  return client;
});
