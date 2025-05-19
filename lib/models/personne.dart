class Personne {
  final int? id;
  final String nom;
  final String prenom;
  final String telephone;
  final String dateNaissance;
  final String lieuNaissance;
  final String role; // "proprietaire" ou "habitant"
  final int maisonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Personne({
    this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.dateNaissance,
    required this.lieuNaissance,
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
      prenom: map['prenom'] ?? '',
      telephone: map['telephone'] ?? '',
      dateNaissance: map['date_naissance'] ?? '',
      lieuNaissance: map['lieu_naissance'] ?? '',
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
      'prenom': prenom,
      'telephone': telephone,
      'date_naissance': dateNaissance,
      'lieu_naissance': lieuNaissance,
      'role': role,
      'maison_id': maisonId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Personne copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? dateNaissance,
    String? lieuNaissance,
    String? role,
    int? maisonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Personne(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      lieuNaissance: lieuNaissance ?? this.lieuNaissance,
      role: role ?? this.role,
      maisonId: maisonId ?? this.maisonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
