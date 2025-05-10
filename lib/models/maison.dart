class Maison {
  final int? id;
  final String adresse;
  final int quartierId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Maison({
    this.id,
    required this.adresse,
    required this.quartierId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  
  factory Maison.fromMap(Map<String, dynamic> map) {
    return Maison(
      id: map['id'],
      adresse: map['adresse'] ?? '',                     // ✅ sécurise si null
      quartierId: map['quartier_id'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adresse': adresse,
      'quartier_id': quartierId,        // ✅ OK
      'created_at': createdAt.toIso8601String(),  // ✅ snake_case
      'updated_at': updatedAt.toIso8601String(),  // ✅ snake_case
    };
  }

  Maison copyWith({
    int? id,
    String? adresse,
    int? quartierId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Maison(
      id: id ?? this.id,
      adresse: adresse ?? this.adresse,
      quartierId: quartierId ?? this.quartierId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}