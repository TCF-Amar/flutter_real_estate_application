import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/utils/location_permission_util.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/explore/views/screens/explore_screen.dart';
import 'package:real_estate_app/features/home/views/screens/home_screen.dart';
import 'package:real_estate_app/features/main/views/widgets/bottom_nav.dart';
import 'package:real_estate_app/features/favorite/views/screens/saved_screen.dart';
import 'package:real_estate_app/features/my_booking/views/screens/my_booking_screen.dart';
import 'package:real_estate_app/features/profile/views/screens/profile_screen.dart';
import 'package:real_estate_app/features/shared/widgets/location_permission_dialog.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<AuthController>().getCurrentUser();
    checkLocationPermission(Get.context!);
  }

  final List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const FavoriteScreen(),
    const MyBookingScreen(),
    const ProfileScreen(),
  ];

  final List<NavItem> navItems = [
    NavItem(
      icon: Assets.icons.home,
      iconSelected: Assets.icons.homeSelected,
      label: "Home",
    ),
    NavItem(
      icon: Assets.icons.search,
      iconSelected: Assets.icons.searchSelected,
      label: "Explore",
    ),
    NavItem(
      icon: Assets.icons.heart,
      iconSelected: Assets.icons.heartSelected,
      label: "Favorites",
    ),
    NavItem(
      icon: Assets.icons.booking,
      iconSelected: Assets.icons.bookingSelected,
      label: "My Bookings",
    ),
    NavItem(
      icon: Assets.icons.person,
      iconSelected: Assets.icons.personSelected,
      label: "Profile",
    ),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> checkLocationPermission(BuildContext context) async {
    final hasPermission = await LocationPermissionUtil.hasPermission();

    if (!hasPermission && context.mounted) {
      await showLocationDialog(context);
    }
  }
}
