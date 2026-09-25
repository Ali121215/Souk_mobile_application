class AppUser {
  final String id;
  final String? telephone;
  final String? email;

  AppUser({required this.id, this.telephone, this.email});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
    );
  }

  String get contactAffiche => telephone ?? email ?? '';
}