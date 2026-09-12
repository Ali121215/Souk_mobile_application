import 'package:dio/dio.dart';

/// Adresse de l'API backend.
///
/// - Émulateur Android : 10.0.2.2 pointe vers le localhost de votre machine.
/// - Simulateur iOS / navigateur : localhost fonctionne directement.
/// - Téléphone physique : remplacer par l'IP locale de votre machine (ex: 192.168.1.X).
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000/api/v1',
);

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));
}
