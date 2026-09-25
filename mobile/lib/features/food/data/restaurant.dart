class Restaurant {
  final String id;
  final String nom;
  final String ville;
  final double note;
  final int fraisLivraisonFcfa;
  final int delaiLivraisonMinutes;

  Restaurant({
    required this.id,
    required this.nom,
    required this.ville,
    required this.note,
    required this.fraisLivraisonFcfa,
    required this.delaiLivraisonMinutes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      nom: json['nom'] as String,
      ville: json['ville'] as String,
      note: (json['note'] as num?)?.toDouble() ?? 0,
      fraisLivraisonFcfa: (json['fraisLivraisonFcfa'] as num?)?.toInt() ?? 0,
      delaiLivraisonMinutes: (json['delaiLivraisonMinutes'] as num?)?.toInt() ?? 30,
    );
  }

  String get fraisAffiche => fraisLivraisonFcfa == 0 ? 'Livraison gratuite' : '$fraisLivraisonFcfa FCFA';
}

class MenuItem {
  final String id;
  final String nom;
  final int prixFcfa;

  MenuItem({required this.id, required this.nom, required this.prixFcfa});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prixFcfa: (json['prixFcfa'] as num).toInt(),
    );
  }

  String get prixAffiche => '$prixFcfa FCFA';
}
