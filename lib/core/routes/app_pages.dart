import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/views/screens/forgot_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_in_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_up_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/reset_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/select_country_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/verity_code.dart';
import 'package:real_estate_app/features/initial/views/screens/get_start_screens.dart';
import 'package:real_estate_app/features/initial/views/screens/splash_screen.dart';

import 'package:real_estate_app/features/main/views/screens/main_screen.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      // binding: SplashBinding(),
    ),
    GetPage(name: AppRoutes.getStart, page: () => GetStartScreens()),
    GetPage(name: AppRoutes.signin, page: () => SignInScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.verifyCode, page: () => VerifyCodeScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: AppRoutes.selectCountry, page: () => SelectCountryScreen()),
    GetPage(name: AppRoutes.main, page: () => MainScreen()),
  ];
}
