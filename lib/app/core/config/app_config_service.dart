import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

/// Service for managing application configuration
/// Handles persistent storage of app settings using SharedPreferences
class AppConfigService {
  static const String _configKey = 'app_config';

  SharedPreferences? _prefs;
  AppConfig _config = AppConfig.defaultConfig();

  /// Singleton instance
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;
  AppConfigService._internal();

  /// Gets the current configuration
  AppConfig get config => _config;

  /// Gets the AI vector database path
  String? get aiVectorDatabasePath => _config.aiVectorDatabasePath;

  /// Initializes the config service
  /// Must be called before using the service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadConfig();
  }

  /// Loads configuration from persistent storage
  Future<void> _loadConfig() async {
    try {
      final configString = _prefs?.getString(_configKey);
      if (configString != null && configString.isNotEmpty) {
        final configMap = jsonDecode(configString) as Map<String, dynamic>;
        _config = AppConfig.fromMap(configMap);
      } else {
        _config = AppConfig.defaultConfig();
      }
    } catch (e) {
      // If there's an error loading config, use default
      _config = AppConfig.defaultConfig();
    }
  }

  /// Saves configuration to persistent storage
  Future<void> _saveConfig() async {
    try {
      final configString = jsonEncode(_config.toMap());
      await _prefs?.setString(_configKey, configString);
    } catch (e) {
      throw ConfigServiceException('Failed to save configuration: $e');
    }
  }

  /// Sets the AI vector database path
  Future<void> setAiVectorDatabasePath(String? path) async {
    _config = _config.copyWith(aiVectorDatabasePath: path);
    await _saveConfig();
  }

  /// Updates the entire configuration
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
    await _saveConfig();
  }

  /// Resets configuration to default values
  Future<void> resetToDefaults() async {
    _config = AppConfig.defaultConfig();
    await _saveConfig();
  }

  /// Clears all stored configuration
  Future<void> clearConfig() async {
    await _prefs?.remove(_configKey);
    _config = AppConfig.defaultConfig();
  }

  /// Checks if the service is initialized
  bool get isInitialized => _prefs != null;
}

/// Exception thrown by the config service
class ConfigServiceException implements Exception {
  final String message;

  const ConfigServiceException(this.message);

  @override
  String toString() => 'ConfigServiceException: $message';
}
