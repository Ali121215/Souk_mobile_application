import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/city_picker.dart';
import 'features/listings/home_screen.dart';
import 'features/listings/listings_providers.dart';
import 'features/food/restaurants_screen.dart';
import 'features/listings/publish_screen.dart';
import 'features/messaging/messages_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  // ProviderScope est requis une seule fois, à la racine, pour que tous les
  // providers Riverpod (listingsProvider, etc.) fonctionnent dans l'app.
  runApp(const ProviderScope(child: SoukApp()));
}

class SoukApp extends StatelessWidget {
  const SoukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Souk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const RootShell(),
    );
  }
}

/// Coquille principale : reprend les 5 onglets validés dans la maquette
/// (Accueil, Repas, Publier, Messages, Profil).
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    RestaurantsScreen(),
    PublishScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Souk'),
        centerTitle: false,
        actions: [
          // Sélecteur de ville — disponible sur tous les onglets, comme sur la maquette.
          TextButton.icon(
            onPressed: () async {
              final chosen = await showCityPicker(context, current: selectedCity);
              if (chosen != null) {
                ref.read(selectedCityProvider.notifier).state = chosen;
              }
            },
            icon: const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
            label: Text(selectedCity, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Repas'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Publier'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
