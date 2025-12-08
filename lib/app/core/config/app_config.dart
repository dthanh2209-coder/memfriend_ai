/// App configuration data model
class AppConfig {
  final String? aiVectorDatabasePath;

  const AppConfig({this.aiVectorDatabasePath});

  /// Creates a copy of this configuration with the given fields replaced
  AppConfig copyWith({String? aiVectorDatabasePath}) {
    return AppConfig(
      aiVectorDatabasePath: aiVectorDatabasePath ?? this.aiVectorDatabasePath,
    );
  }

  /// Converts this configuration to a map for storage
  Map<String, dynamic> toMap() {
    return {'ai_vector_database_path': aiVectorDatabasePath};
  }

  /// Creates configuration from a map
  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      aiVectorDatabasePath: map['ai_vector_database_path'] as String?,
    );
  }

  /// Creates an empty configuration with default values
  factory AppConfig.defaultConfig() {
    return const AppConfig(aiVectorDatabasePath: null);
  }

  @override
  String toString() {
    return 'AppConfig(aiVectorDatabasePath: $aiVectorDatabasePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppConfig &&
        other.aiVectorDatabasePath == aiVectorDatabasePath;
  }

  @override
  int get hashCode {
    return aiVectorDatabasePath.hashCode;
  }
}
