/// Reflète la réponse enrichie de GET /api/v1/listings/:id (inclut le vendeur).
class ListingDetail {
  final String id;
  final String titre;
  final String? description;
  final String categorie;
  final int prixFcfa;
  final String ville;
  final String? vendeurTelephone;
  final String vendeurNom;

  ListingDetail({
    required this.id,
    required this.titre,
    this.description,
    required this.categorie,
    required this.prixFcfa,
    required this.ville,
    this.vendeurTelephone,
    required this.vendeurNom,
  });

  factory ListingDetail.fromJson(Map<String, dynamic> json) {
    return ListingDetail(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      categorie: json['categorie'] as String,
      prixFcfa: json['prixFcfa'] as int,
      ville: json['ville'] as String,
      vendeurTelephone: json['vendeurTelephone'] as String?,
      vendeurNom: json['vendeurNom'] as String? ?? 'Vendeur Souk',
    );
  }

  String get prixAffiche {
    final s = prixFcfa.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(s[i]);
    }
    return '${buffer.toString()} FCFA';
  }
}
