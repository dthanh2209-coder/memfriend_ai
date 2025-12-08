class Person {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final String? relation;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Person({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.relation,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      phone: map['phone'],
      address: map['address'],
      relation: map['relation'],
      note: map['note'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'relation': relation,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Person copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? relation,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      relation: relation ?? this.relation,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Person(id: $id, name: $name, phone: $phone, address: $address, relation: $relation, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.relation == relation &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        relation.hashCode ^
        note.hashCode;
  }
}
