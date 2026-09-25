import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'my_orders_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commande envoyee')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 18),
              const Text('Commande envoyee !', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Le restaurant a recu votre commande et va la preparer.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                    (route) => route.isFirst,
                  ),
                  child: const Text('Suivre ma commande'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Retour a l accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
