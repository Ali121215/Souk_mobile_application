import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../listings/listings_providers.dart';
import 'data/app_user.dart';
import 'data/auth_repository.dart';

const _tokenStorageKey = 'souk_auth_token';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

/// Token JWT de l'utilisateur connecté, ou null s'il n'est pas connecté.
/// AsyncNotifier permet de le charger depuis le stockage sécurisé au démarrage
/// de l'app (pour rester connecté entre deux ouvertures de l'app).
class AuthTokenNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final storage = ref.watch(secureStorageProvider);
    return storage.read(key: _tokenStorageKey);
  }

  Future<void> setToken(String token) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _tokenStorageKey, value: token);
    state = AsyncData(token);
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: _tokenStorageKey);
    state = const AsyncData(null);
  }
}

final authTokenProvider = AsyncNotifierProvider<AuthTokenNotifier, String?>(AuthTokenNotifier.new);

/// Pratique pour savoir rapidement, dans l'interface, si quelqu'un est connecté.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authTokenProvider).valueOrNull != null;
});

final currentUserProvider = StateProvider<AppUser?>((ref) => null);
