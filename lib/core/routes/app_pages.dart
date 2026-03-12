import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/agent/bindings/agent_binding.dart';
import 'package:real_estate_app/features/agent/view/screens/agent_detail_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/forgot_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_in_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_up_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/reset_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/select_country_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/verity_code.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/profile/views/screens/change_password.dart';
import 'package:real_estate_app/features/profile/views/screens/delete_account.dart';
import 'package:real_estate_app/features/profile/views/screens/profile_edit.dart';
import 'package:real_estate_app/features/profile/views/screens/setting_screen.dart';
import 'package:real_estate_app/features/profile/views/screens/support/new_request.dart';
import 'package:real_estate_app/features/profile/views/screens/support/support_details.dart';
import 'package:real_estate_app/features/profile/views/screens/support/support_screen.dart';
import 'package:real_estate_app/features/property/bindings/property_details_binding.dart';
import 'package:real_estate_app/features/property/views/screens/property_details_screen.dart';
import 'package:real_estate_app/features/initial/views/screens/get_start_screens.dart';
import 'package:real_estate_app/features/initial/views/screens/splash_screen.dart';
import 'package:real_estate_app/features/main/bindings/main_binding.dart';
import 'package:real_estate_app/features/main/views/screens/main_screen.dart';
import 'package:real_estate_app/features/search/views/screens/search_result.dart';
import 'package:real_estate_app/features/search/views/screens/search_screen.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.getStart, page: () => GetStartScreens()),
    GetPage(name: AppRoutes.signin, page: () => SignInScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.verifyCode, page: () => VerifyCodeScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(
      name: AppRoutes.selectCountry,
      page: () {
        final opPress = Get.arguments['onPress'];
        
        return SelectCountryScreen(onPress: opPress);
      },
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
      bindings: [MainBinding()],
    ),
    GetPage(name: AppRoutes.search, page: () => SearchScreen()),
    GetPage(
      name: AppRoutes.searchResult,
      page: () => SearchResult(query: Get.arguments['query']),
    ),
    GetPage(
      name: AppRoutes.propertyDetails,
      page: () => PropertyDetailsScreen(),
      binding: PropertyDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.agentDetails,
      page: () => AgentDetailScreen(),
      binding: AgentDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () {
        final authController = Get.find<AuthController>();
        final user = authController.user.value;
        if (user == null) {
          Get.back();
          return const SizedBox.shrink();
        }
        // Pre-fill text controllers with the latest user data
        Get.find<ProfileController>().initForEdit(user);
        return ProfileEdit(user: user);
      },
    ),
    GetPage(name: AppRoutes.support, page: () => SupportScreen()),

    GetPage(name: AppRoutes.newRequest, page: () => NewRequest()),
    GetPage(name: AppRoutes.supportDetails, page: () => SupportDetails()),

    GetPage(name: AppRoutes.accountDelete, page: () => DeleteAccount()),
    GetPage(name: AppRoutes.changePassword, page: () => ChangePassword()),
    GetPage(name: AppRoutes.settings, page: () => SettingScreen()),
  ];
}
