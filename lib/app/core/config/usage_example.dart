// Example of how to use the AppConfigService
// This file shows various ways to interact with the configuration

import 'config.dart';

/// Example class showing how to use the AppConfigService
class ConfigUsageExample {
  /// Example: Setting the AI vector database path
  static Future<void> setupAiVectorDatabase() async {
    // Set the path to where AI vector database should be stored
    const databasePath = '/data/user/0/com.mem_friend/files/ai_vectors.db';
    await ConfigHelper.setAiVectorDatabasePath(databasePath);

    print('AI Vector Database path set to: $databasePath');
  }

  /// Example: Getting the AI vector database path
  static void getAiVectorDatabasePath() {
    final path = ConfigHelper.aiVectorDatabasePath;

    if (ConfigHelper.hasAiVectorDatabasePath) {
      print('AI Vector Database path: $path');
    } else {
      print('AI Vector Database path not configured');
    }
  }

  /// Example: Using the service directly for more control
  static Future<void> directServiceUsage() async {
    final configService = AppConfigService();

    // Check if service is initialized
    if (!configService.isInitialized) {
      print('Config service not initialized!');
      return;
    }

    // Get current config
    final currentConfig = configService.config;
    print('Current config: $currentConfig');

    // Update specific setting
    await configService.setAiVectorDatabasePath('/custom/path/vectors.db');

    // Or update entire config
    final newConfig = currentConfig.copyWith(
      aiVectorDatabasePath: '/another/path/vectors.db',
    );
    await configService.updateConfig(newConfig);
  }

  /// Example: Resetting configuration
  static Future<void> resetConfiguration() async {
    await ConfigHelper.resetToDefaults();
    print('Configuration reset to defaults');
  }

  /// Example: Clearing all stored configuration
  static Future<void> clearAllConfig() async {
    await ConfigHelper.clearConfig();
    print('All configuration cleared');
  }
}
