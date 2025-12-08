import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: Text(AppStrings.settings.tr));
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _buildLanguageSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader(title: AppStrings.language.tr, icon: Icons.language),
          const Divider(height: 1),
          Obx(
            () => Column(
              children: controller.languages.map((language) {
                final isSelected =
                    controller.currentLanguage.value == language['code'];
                return ListTile(
                  title: Text(language['name']!),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppTheme.accentColor)
                      : null,
                  selected: isSelected,
                  onTap: () => controller.changeLanguage(language['code']!),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Column(
        children: [
          _buildSectionHeader(title: AppStrings.about.tr, icon: Icons.info),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppStrings.about.tr),
            subtitle: Text('${AppStrings.version.tr} 1.0.0'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.showAboutDialog,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(AppStrings.privacy.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.showPrivacyDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0:
            controller.goToHome();
            break;
          case 1:
            controller.goToRecognition();
            break;
          case 2:
            // Already on settings
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppStrings.home.tr),
        BottomNavigationBarItem(
          icon: const Icon(Icons.face),
          label: AppStrings.recognition.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppStrings.settings.tr,
        ),
      ],
    );
  }
}
