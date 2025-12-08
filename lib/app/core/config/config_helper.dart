import 'app_config.dart';
import 'app_config_service.dart';

/// Helper class for common configuration operations
class ConfigHelper {
  static final AppConfigService _configService = AppConfigService();

  /// Gets the current AI vector database path
  static String? get aiVectorDatabasePath =>
      _configService.aiVectorDatabasePath;

  /// Sets the AI vector database path
  static Future<void> setAiVectorDatabasePath(String? path) async {
    await _configService.setAiVectorDatabasePath(path);
  }

  /// Checks if AI vector database path is configured
  static bool get hasAiVectorDatabasePath =>
      _configService.aiVectorDatabasePath != null &&
      _configService.aiVectorDatabasePath!.isNotEmpty;

  /// Gets the full configuration
  static AppConfig get config => _configService.config;

  /// Resets all configuration to defaults
  static Future<void> resetToDefaults() async {
    await _configService.resetToDefaults();
  }

  /// Clears all stored configuration
  static Future<void> clearConfig() async {
    await _configService.clearConfig();
  }
}
