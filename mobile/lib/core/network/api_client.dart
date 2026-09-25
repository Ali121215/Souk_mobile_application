import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Adresse de l'API backend, devinée automatiquement selon la plateforme :
/// - Web (Chrome) : localhost fonctionne directement.
/// - Émulateur Android : 10.0.2.2 pointe vers le localhost de la machine hôte.
/// - Téléphone physique : à remplacer par l'IP locale de votre machine.
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: kIsWeb ? 'http://localhost:3000/api/v1' : 'http://10.0.2.2:3000/api/v1',
);

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));
}