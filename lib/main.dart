import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_friend/app/core/ai/vi_face_core.dart';

import 'app/core/config/config.dart';
import 'app/core/localization/app_translations.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/values/app_strings.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration service
  await AppConfigService().initialize();

  runApp(const MemFriendApp());
}

class MemFriendApp extends StatefulWidget {
  const MemFriendApp({super.key});

  @override
  State<MemFriendApp> createState() => _MemFriendAppState();
}

class _MemFriendAppState extends State<MemFriendApp> {
  @override
  void initState() {
    super.initState();
    // run in post frame callback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ViFaceCore.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName.tr,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      transitionDuration: const Duration(milliseconds: 300),
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
