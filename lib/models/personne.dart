class Personne {
  final int? id;
  final String nom;
  final String telephone;
  final String email;
  final String role; // "proprietaire" ou "habitant"
  final int maisonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Personne({
    this.id,
    required this.nom,
    required this.telephone,
    required this.email,
    required this.role,
    required this.maisonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Personne.fromMap(Map<String, dynamic> map) {
    return Personne(
      id: map['id'],
      nom: map['nom'] ?? '',
      telephone: map['telephone'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      maisonId: map['maison_id'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'telephone': telephone,
      'email': email,
      'role': role,
      'maison_id': maisonId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Personne copyWith({
    int? id,
    String? nom,
    String? telephone,
    String? email,
    String? role,
    int? maisonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Personne(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      role: role ?? this.role,
      maisonId: maisonId ?? this.maisonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
