import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/di/initial_di.dart';
import 'package:real_estate_app/core/routes/app_pages.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/theme/app_theme.dart';
import 'package:real_estate_app/features/auth/bindings/auth_binding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:real_estate_app/core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env.development");
  InitialDi.init();

  final translations = await AppTranslations.load();

  runApp(MainApp(translations: translations));
}

class MainApp extends StatelessWidget {
  final AppTranslations translations;

  const MainApp({super.key, required this.translations});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      initialBinding: AuthBinding(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      translations: translations,
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      // builder: (context, child) {
      //   return Directionality(textDirection: TextDirection., child: child!);
      // },
    );
  }
}
