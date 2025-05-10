class Quartier {
  final int? id;
  final String nom;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quartier({
    this.id,
    required this.nom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Quartier.fromMap(Map<String, dynamic> map) {
    return Quartier(
      id: map['id'],
      nom: map['nom'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Quartier copyWith({
    int? id,
    String? nom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quartier(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Quartier(id: $id, nom: $nom)';
  }
}