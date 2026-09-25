import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'data/food_order.dart';
import 'food_providers.dart';

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes repas')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myOrdersProvider.future),
        child: ordersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Impossible de charger vos commandes.', style: const TextStyle(color: AppColors.clay)),
              ),
            ],
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Vous n avez pas encore commande de repas.', style: TextStyle(color: AppColors.muted)),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _OrderCard(order: orders[index]),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final FoodOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final currentStep = orderStatusSteps.indexOf(order.statut);
    final isAnnulee = order.statut == 'annulee';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.restaurantNom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(order.totalAffiche, style: const TextStyle(color: AppColors.clay, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (isAnnulee)
            const Text('Commande annulee', style: TextStyle(color: AppColors.clay, fontWeight: FontWeight.bold))
          else
            Row(
              children: List.generate(orderStatusSteps.length, (i) {
                final done = i <= currentStep;
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (i > 0) Expanded(child: Container(height: 2, color: i <= currentStep ? AppColors.green : AppColors.line)),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? AppColors.green : AppColors.line,
                            ),
                            child: done ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                          ),
                          if (i < orderStatusSteps.length - 1)
                            Expanded(child: Container(height: 2, color: i < currentStep ? AppColors.green : AppColors.line)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        orderStatusLabels[orderStatusSteps[i]] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9, color: done ? AppColors.ink : AppColors.muted, fontWeight: done ? FontWeight.bold : FontWeight.normal),
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
