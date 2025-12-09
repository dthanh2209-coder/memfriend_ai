import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_strings.dart';

class SettingsController extends GetxController {
  // Language settings
  final RxString currentLanguage = 'en'.obs;
  final RxList<Map<String, String>> languages = <Map<String, String>>[
    {'code': 'en', 'name': 'English'},
    {'code': 'vi', 'name': 'Tiếng Việt'},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    // Load saved settings from storage
    // For now, using default values
    currentLanguage.value = Get.locale?.languageCode ?? 'en';
  }

  /// Change app language
  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;

    Locale locale;
    switch (languageCode) {
      case 'vi':
        locale = const Locale('vi', 'VN');
        break;
      case 'en':
      default:
        locale = const Locale('en', 'US');
        break;
    }

    Get.updateLocale(locale);

    Get.snackbar(
      'Language Changed',
      'Language has been changed to ${_getLanguageName(languageCode)}',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Get language name by code
  String _getLanguageName(String code) {
    final language = languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'name': 'English'},
    );
    return language['name'] ?? 'English';
  }

  /// Get current language name
  String get currentLanguageName => _getLanguageName(currentLanguage.value);

  /// Navigate to home
  void goToHome() {
    Get.offAllNamed('/home');
  }

  /// Navigate to recognition
  void goToRecognition() {
    Get.offAllNamed('/recognition');
  }

  /// Show about dialog
  void showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.aboutMemfriend.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MemFriend v1.0.0'),
            const SizedBox(height: 8),
            Text(AppStrings.aboutDescription.tr),
            const SizedBox(height: 16),
            Text(AppStrings.features.tr),
            Text(AppStrings.featurePersonManagement.tr),
            Text(AppStrings.featureFaceRecognition.tr),
            Text(AppStrings.featureMemoryEvents.tr),
            Text(AppStrings.featureVoicePronunciation.tr),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.ok.tr),
          ),
        ],
      ),
    );
  }

  /// Show privacy dialog
  void showPrivacyDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.privacyPolicy.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.dataStorage.tr),
              const SizedBox(height: 8),
              Text(AppStrings.dataStorageLocal.tr),
              Text(AppStrings.dataStorageNoServer.tr),
              Text(AppStrings.dataStorageLocalProcessing.tr),
              const SizedBox(height: 16),
              Text(AppStrings.permissions.tr),
              const SizedBox(height: 8),
              Text(AppStrings.permissionCamera.tr),
              Text(AppStrings.permissionStorage.tr),
              const SizedBox(height: 16),
              Text(AppStrings.dataSecurity.tr),
              const SizedBox(height: 8),
              Text(AppStrings.dataSecurityPrivate.tr),
              Text(AppStrings.dataSecurityNoCollection.tr),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.ok.tr),
          ),
        ],
      ),
    );
  }
}
