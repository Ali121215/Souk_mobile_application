class OrderItemLine {
  final String menuItemId;
  final int quantite;
  final int prixUnitaireFcfa;

  OrderItemLine({required this.menuItemId, required this.quantite, required this.prixUnitaireFcfa});

  factory OrderItemLine.fromJson(Map<String, dynamic> json) {
    return OrderItemLine(
      menuItemId: json['menuItemId'] as String,
      quantite: (json['quantite'] as num).toInt(),
      prixUnitaireFcfa: (json['prixUnitaireFcfa'] as num).toInt(),
    );
  }
}

class FoodOrder {
  final String id;
  final String restaurantId;
  final String restaurantNom;
  final String statut;
  final int totalFcfa;
  final String? adresseLivraison;
  final List<OrderItemLine> articles;

  FoodOrder({
    required this.id,
    required this.restaurantId,
    required this.restaurantNom,
    required this.statut,
    required this.totalFcfa,
    this.adresseLivraison,
    required this.articles,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantNom: json['restaurantNom'] as String? ?? 'Restaurant',
      statut: json['statut'] as String,
      totalFcfa: (json['totalFcfa'] as num).toInt(),
      adresseLivraison: json['adresseLivraison'] as String?,
      articles: (json['articles'] as List<dynamic>? ?? [])
          .map((a) => OrderItemLine.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  String get totalAffiche => '$totalFcfa FCFA';
}

const List<String> orderStatusSteps = ['recue', 'en_preparation', 'en_livraison', 'livree'];

const Map<String, String> orderStatusLabels = {
  'recue': 'Commande recue',
  'en_preparation': 'En preparation',
  'en_livraison': 'En livraison',
  'livree': 'Livree',
  'annulee': 'Annulee',
};
