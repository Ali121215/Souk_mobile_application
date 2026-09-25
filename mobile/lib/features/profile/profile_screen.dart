import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_providers.dart';
import '../auth/login_screen.dart';
import '../listings/my_listings_screen.dart';
import '../food/my_orders_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(currentUserProvider);

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: AppColors.gold, child: Text('D')),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isLoggedIn ? 'Mon compte' : 'Non connecte', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(user?.contactAffiche.isNotEmpty == true ? user!.contactAffiche : 'Connectez-vous pour publier ou commander', style: const TextStyle(color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (!isLoggedIn)
            _ProfileRow(
              label: 'Se connecter',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
            )
          else ...[
            _ProfileRow(
              label: 'Mes annonces',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyListingsScreen())),
            ),
            _ProfileRow(
              label: 'Mes commandes repas',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyOrdersScreen())),
            ),
            _ProfileRow(label: 'Mes candidatures emploi'),
            _ProfileRow(label: 'Favoris'),
            _ProfileRow(label: 'Moyens de paiement'),
            _ProfileRow(
              label: 'Se deconnecter',
              onTap: () async {
                await ref.read(authTokenProvider.notifier).logout();
                ref.read(currentUserProvider.notifier).state = null;
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _ProfileRow({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      onTap: onTap ?? () {},
    );
  }
}

