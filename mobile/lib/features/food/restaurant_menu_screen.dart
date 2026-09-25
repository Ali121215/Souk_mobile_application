import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'data/restaurant.dart';
import 'food_providers.dart';
import 'cart_screen.dart';

class RestaurantMenuScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const RestaurantMenuScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends ConsumerState<RestaurantMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentCartRestaurant = ref.read(cartRestaurantIdProvider);
      if (currentCartRestaurant != widget.restaurant.id) {
        ref.read(cartProvider.notifier).clear();
        ref.read(cartRestaurantIdProvider.notifier).state = widget.restaurant.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuProvider(widget.restaurant.id));
    final panier = ref.watch(cartProvider);
    final totalArticles = panier.values.fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.nom)),
      body: Stack(
        children: [
          menuAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Impossible de charger le menu.', style: const TextStyle(color: AppColors.clay)),
            ),
            data: (menu) {
              if (menu.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Ce restaurant n a pas encore de plats disponibles.', style: TextStyle(color: AppColors.muted)),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemCount: menu.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = menu[index];
                  final quantite = panier[item.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              const SizedBox(height: 3),
                              Text(item.prixAffiche, style: const TextStyle(color: AppColors.clay, fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        if (quantite == 0)
                          IconButton(
                            onPressed: () => ref.read(cartProvider.notifier).add(item.id),
                            icon: const Icon(Icons.add_circle, color: AppColors.primary),
                          )
                        else
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => ref.read(cartProvider.notifier).changeQuantity(item.id, -1),
                                icon: const Icon(Icons.remove_circle_outline, color: AppColors.clay),
                              ),
                              Text('$quantite', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () => ref.read(cartProvider.notifier).changeQuantity(item.id, 1),
                                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          if (totalArticles > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.clay,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CartScreen(restaurant: widget.restaurant)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$totalArticles article(s)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Text('Voir le panier ->', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
