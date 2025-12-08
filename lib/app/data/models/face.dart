import 'dart:convert';
import 'dart:typed_data';

class Face {
  final int? id;
  final int personId;
  final String path;
  final List<double> vector;
  final DateTime updatedTime;

  Face({
    this.id,
    required this.personId,
    required this.path,
    required this.vector,
    required this.updatedTime,
  });

  factory Face.fromMap(Map<String, dynamic> map) {
    return Face(
      id: map['id']?.toInt(),
      personId: map['person_id']?.toInt() ?? 0,
      path: map['path'] ?? '',
      vector: _vectorFromBlob(map['vector']),
      updatedTime: DateTime.parse(map['updated_time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'person_id': personId,
      'path': path,
      'vector': _vectorToBlob(vector),
      'updated_time': updatedTime.toIso8601String(),
    };
  }

  Face copyWith({
    int? id,
    int? personId,
    String? path,
    List<double>? vector,
    DateTime? updatedTime,
  }) {
    return Face(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      path: path ?? this.path,
      vector: vector ?? this.vector,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  @override
  String toString() {
    return 'Face(id: $id, personId: $personId, path: $path, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Face &&
        other.id == id &&
        other.personId == personId &&
        other.path == path;
  }

  @override
  int get hashCode {
    return id.hashCode ^ personId.hashCode ^ path.hashCode;
  }

  /// Convert List<double> to Uint8List for BLOB storage in SQLite
  static Uint8List _vectorToBlob(List<double> vector) {
    final jsonString = jsonEncode(vector);
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  /// Convert BLOB data from SQLite back to List<double>
  static List<double> _vectorFromBlob(dynamic blob) {
    if (blob == null) return [];

    // Handle different possible types from SQLite
    late String jsonString;
    if (blob is Uint8List) {
      jsonString = utf8.decode(blob);
    } else if (blob is List<int>) {
      jsonString = utf8.decode(Uint8List.fromList(blob));
    } else if (blob is String) {
      jsonString = blob;
    } else {
      throw ArgumentError('Unsupported blob type: ${blob.runtimeType}');
    }

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded
        .map<double>((e) => e is int ? e.toDouble() : e as double)
        .toList();
  }
}
