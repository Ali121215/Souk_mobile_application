import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'food_providers.dart';
import 'restaurant_menu_screen.dart';

class RestaurantsScreen extends ConsumerWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(restaurantsProvider.future),
        child: restaurantsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Impossible de charger les restaurants.', style: const TextStyle(color: AppColors.clay)),
              ),
            ],
          ),
          data: (restaurants) {
            if (restaurants.isEmpty) {
              return ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Aucun restaurant ne livre encore dans cette ville.', style: TextStyle(color: AppColors.muted)),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: restaurants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RestaurantMenuScreen(restaurant: restaurant)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.restaurant, color: AppColors.muted),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(restaurant.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 13, color: AppColors.gold),
                                  Text(' ${restaurant.note}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 10),
                                  Text('${restaurant.delaiLivraisonMinutes} min', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(restaurant.fraisAffiche, style: const TextStyle(fontSize: 11.5, color: AppColors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.muted),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
