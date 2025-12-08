class MemoryEvent {
  final int? id;
  final int personId;
  final String name;
  final String? content;
  final String imagePath;
  final DateTime updatedTime;

  MemoryEvent({
    this.id,
    required this.personId,
    required this.name,
    this.content,
    required this.imagePath,
    required this.updatedTime,
  });

  factory MemoryEvent.fromMap(Map<String, dynamic> map) {
    return MemoryEvent(
      id: map['id']?.toInt(),
      personId: map['person_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      content: map['content'],
      imagePath: map['image_path'] ?? '',
      updatedTime: DateTime.parse(map['updated_time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'name': name,
      'content': content,
      'image_path': imagePath,
      'updated_time': updatedTime.toIso8601String(),
    };
  }

  MemoryEvent copyWith({
    int? id,
    int? personId,
    String? name,
    String? content,
    String? imagePath,
    DateTime? updatedTime,
  }) {
    return MemoryEvent(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      name: name ?? this.name,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  @override
  String toString() {
    return 'MemoryEvent(id: $id, personId: $personId, name: $name, content: $content, imagePath: $imagePath, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MemoryEvent &&
        other.id == id &&
        other.personId == personId &&
        other.name == name &&
        other.content == content &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        personId.hashCode ^
        name.hashCode ^
        content.hashCode ^
        imagePath.hashCode;
  }
}
