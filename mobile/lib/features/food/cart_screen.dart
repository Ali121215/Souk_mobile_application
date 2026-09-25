import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_providers.dart';
import '../auth/login_screen.dart';
import 'data/restaurant.dart';
import 'food_providers.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const CartScreen({super.key, required this.restaurant});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _adresseController = TextEditingController(text: 'Domicile');
  bool _loading = false;
  String? _erreur;

  Future<void> _commander(Map<String, int> panier) async {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!isLoggedIn) {
      final loggedIn = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (loggedIn != true) return;
    }

    setState(() {
      _loading = true;
      _erreur = null;
    });

    try {
      await ref.read(restaurantsRepositoryProvider).createOrder(
            restaurantId: widget.restaurant.id,
            panier: panier,
            adresseLivraison: _adresseController.text.trim(),
          );
      ref.read(cartProvider.notifier).clear();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()),
        );
      }
    } catch (e) {
      setState(() => _erreur = 'Impossible de passer la commande. Reessayez.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final panier = ref.watch(cartProvider);
    final menuAsync = ref.watch(menuProvider(widget.restaurant.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Mon panier')),
      body: menuAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(child: Text('Erreur de chargement.')),
        data: (menu) {
          if (panier.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Votre panier est vide', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
              ),
            );
          }

          final sousTotal = cartSubtotal(panier, menu);
          final fraisLivraison = widget.restaurant.fraisLivraisonFcfa;
          final total = sousTotal + fraisLivraison;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...panier.entries.map((entry) {
                      final item = menu.where((m) => m.id == entry.key).toList();
                      if (item.isEmpty) return const SizedBox.shrink();
                      final menuItem = item.first;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(menuItem.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text(menuItem.prixAffiche, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => ref.read(cartProvider.notifier).changeQuantity(entry.key, -1),
                              icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.clay),
                            ),
                            Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => ref.read(cartProvider.notifier).changeQuantity(entry.key, 1),
                              icon: const Icon(Icons.add_circle, size: 20, color: AppColors.primary),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _adresseController,
                      decoration: const InputDecoration(labelText: 'Adresse de livraison', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    _SumRow(label: 'Sous-total', value: '$sousTotal FCFA'),
                    _SumRow(label: 'Frais de livraison', value: fraisLivraison == 0 ? 'Gratuit' : '$fraisLivraison FCFA'),
                    const Divider(),
                    _SumRow(label: 'Total', value: '$total FCFA', bold: true),
                    if (_erreur != null) ...[
                      const SizedBox(height: 10),
                      Text(_erreur!, style: const TextStyle(color: AppColors.clay)),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : () => _commander(panier),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.clay, padding: const EdgeInsets.all(16)),
                    child: _loading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Commander'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SumRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 15 : 13);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style.copyWith(color: bold ? AppColors.ink : AppColors.muted)), Text(value, style: style)],
      ),
    );
  }
}
