class Listing {
  final String id;
  final String titre;
  final String categorie;
  final int prixFcfa;
  final String ville;
  final String statut;

  Listing({
    required this.id,
    required this.titre,
    required this.categorie,
    required this.prixFcfa,
    required this.ville,
    this.statut = 'publiee',
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      titre: json['titre'] as String,
      categorie: json['categorie'] as String,
      prixFcfa: json['prixFcfa'] as int,
      ville: json['ville'] as String,
      statut: json['statut'] as String? ?? 'publiee',
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
