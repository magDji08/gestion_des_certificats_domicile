class Certificat {
  final int? id;
  final int personneId;
  final String numero;
  final DateTime dateEmission;
  final DateTime createdAt;
  final DateTime updatedAt;

  Certificat({
    this.id,
    required this.personneId,
    required this.numero,
    required this.dateEmission,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Certificat.fromMap(Map<String, dynamic> map) {
    return Certificat(
      id: map['id'],
      personneId: map['personne_id'],
      numero: map['numero'] ?? '',
      dateEmission: DateTime.parse(map['date_emission']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personne_id': personneId,
      'numero': numero,
      'date_emission': dateEmission.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Certificat copyWith({
    int? id,
    int? personneId,
    String? numero,
    DateTime? dateEmission,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Certificat(
      id: id ?? this.id,
      personneId: personneId ?? this.personneId,
      numero: numero ?? this.numero,
      dateEmission: dateEmission ?? this.dateEmission,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
