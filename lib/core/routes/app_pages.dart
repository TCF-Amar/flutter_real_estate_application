import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:real_estate_app/core/routes/app_routes.dart';

// Initial & Onboarding
import 'package:real_estate_app/features/initial/views/screens/get_start_screens.dart';
import 'package:real_estate_app/features/initial/views/screens/splash_screen.dart';

// Auth
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/views/screens/forgot_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/reset_password_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/select_country_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_in_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/sign_up_screen.dart';
import 'package:real_estate_app/features/auth/views/screens/verity_code.dart';

// Main
import 'package:real_estate_app/features/main/bindings/main_binding.dart';
import 'package:real_estate_app/features/main/views/screens/main_screen.dart';
import 'package:real_estate_app/features/my_booking/bindings/my_bokking_binding.dart';
import 'package:real_estate_app/features/my_booking/bindings/visit_details_binding.dart';
import 'package:real_estate_app/features/my_booking/views/screens/booking_details_screen.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/booking_flow_screen.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/visit_details_screen.dart';
import 'package:real_estate_app/features/search/bindings/search_binding.dart';

// Search
import 'package:real_estate_app/features/search/views/screens/search_result.dart';
import 'package:real_estate_app/features/search/views/screens/search_screen.dart';

// Property
import 'package:real_estate_app/features/property/bindings/property_details_binding.dart';
import 'package:real_estate_app/features/property/views/screens/property_details_screen.dart';

// Agent
import 'package:real_estate_app/features/agent/bindings/agent_binding.dart';
import 'package:real_estate_app/features/agent/view/screens/agent_detail_screen.dart';

// Profile & Settings
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/profile/views/screens/change_password.dart';
import 'package:real_estate_app/features/profile/views/screens/delete_account.dart';
import 'package:real_estate_app/features/profile/views/screens/profile_edit.dart';
import 'package:real_estate_app/features/profile/views/screens/setting_screen.dart';

// Support
import 'package:real_estate_app/features/profile/views/screens/support/new_request.dart';
import 'package:real_estate_app/features/profile/views/screens/support/support_details.dart';
import 'package:real_estate_app/features/profile/views/screens/support/support_screen.dart';
import 'package:real_estate_app/features/shared/screens/test.dart';
import 'package:real_estate_app/features/transactions/bindings/transaction_binding.dart';
import 'package:real_estate_app/features/transactions/views/screens/transaction_history.dart';

class AppPages {
  static final pages = <GetPage>[
    // ─── Initial & Onboarding ──────────────────────────────────────────────
    GetPage(name: AppRoutes.test, page: () => TestScreen()),
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.getStart, page: () => GetStartScreens()),

    // ─── Authentication ───────────────────────────────────────────────────
    GetPage(name: AppRoutes.signin, page: () => SignInScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.verifyCode, page: () => VerifyCodeScreen()),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(
      name: AppRoutes.selectCountry,
      page: () {
        final Map? args = Get.arguments is Map ? Get.arguments as Map : null;
        final opPress = args?['onPress'];
        return SelectCountryScreen(onPress: opPress);
      },
    ),

    // ─── Main Navigation ──────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
      bindings: [MainBinding()],
    ),

    // ─── Search ───────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.search,
      binding: SearchBinding(),
      page: () => SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.searchResult,
      page: () {
        // final Map? args = Get.arguments is Map ? Get.arguments as Map : null;
        return SearchResult();
      },
    ),

    // ─── Property ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.propertyDetails,
      page: () => const PropertyDetailsScreen(),
      binding: PropertyDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.bookVisit,
      page: () => BookingFlowScreen(propertyDetail: Get.arguments),
    ),

    GetPage(
      name: AppRoutes.visitDetails,
      binding: VisitDetailsBinding(),
      page: () => VisitDetails(),
    ),
    // ─── Agent ────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.agentDetails,
      page: () => const AgentDetailScreen(),
      binding: AgentDetailsBinding(),
    ),

    // ─── Profile & User Settings ──────────────────────────────────────────
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
    GetPage(name: AppRoutes.settings, page: () => const SettingScreen()),
    GetPage(name: AppRoutes.changePassword, page: () => const ChangePassword()),
    GetPage(name: AppRoutes.accountDelete, page: () => const DeleteAccount()),

    // ─── Support ──────────────────────────────────────────────────────────
    GetPage(name: AppRoutes.support, page: () => SupportScreen()),
    GetPage(name: AppRoutes.newRequest, page: () => NewRequest()),
    GetPage(name: AppRoutes.supportDetails, page: () => SupportDetails()),

    // ─── Booking ──────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.bookingDetails,
      page: () => BookingDetailsScreen(),
      binding: MyBookingBinding(),
    ),
    GetPage(
      name: AppRoutes.transactionHistory,
      page: () => const TransactionHistory(),
      binding: TransactionBinding(),
    ),
  ];
}
