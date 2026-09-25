import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import 'data/listing_detail.dart';
import 'listings_providers.dart';

class ListingDetailScreen extends ConsumerWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    // wa.me exige un numéro sans "+" ni espaces.
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(listingDetailProvider(listingId));

    return Scaffold(
      appBar: AppBar(title: const Text("Détail de l'annonce")),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Impossible de charger cette annonce.\n\n$error', style: const TextStyle(color: AppColors.clay)),
        ),
        data: (listing) => _ListingDetailBody(listing: listing, onCall: _call, onWhatsapp: _whatsapp),
      ),
    );
  }
}

class _ListingDetailBody extends StatelessWidget {
  final ListingDetail listing;
  final Future<void> Function(String phone) onCall;
  final Future<void> Function(String phone) onWhatsapp;

  const _ListingDetailBody({required this.listing, required this.onCall, required this.onWhatsapp});

  @override
  Widget build(BuildContext context) {
    final hasPhone = listing.vendeurTelephone != null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                child: const Icon(Icons.image_outlined, size: 40, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Text(listing.titre, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(listing.prixAffiche, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.clay)),
              const SizedBox(height: 4),
              Text('📍 ${listing.ville}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              if (listing.description != null && listing.description!.isNotEmpty) ...[
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 6),
                Text(listing.description!, style: const TextStyle(fontSize: 13.5, height: 1.5)),
                const SizedBox(height: 20),
              ],
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 22, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listing.vendeurNom, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Vendeur', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Barre d'actions fixe en bas, comme sur la maquette d'origine.
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasPhone ? () => onCall(listing.vendeurTelephone!) : null,
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Appeler'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasPhone ? () => onWhatsapp(listing.vendeurTelephone!) : null,
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
