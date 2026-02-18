import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/views/screens/forgot_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/login_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/register_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/reset_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/select_country_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/verity_code.dart';
import 'package:real_estate_app/features/initial/views/screens/get_start_screens.dart';
import 'package:real_estate_app/features/initial/views/screens/splash_screen.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(name: AppRoutes.getStart, page: () => GetStartScreens()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.verifyCode, page: () => VerifyCodeScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: AppRoutes.selectCountry, page: () => SelectCountryScreen()),
  ];
}
