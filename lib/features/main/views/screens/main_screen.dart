import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/home/views/screens/home_screen.dart';
import 'package:real_estate_app/features/main/views/widgets/bottom_nav.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;
    final AuthController authController = Get.find<AuthController>();

    final List<Widget> screens = [
      HomeScreen(),
      Center(
        child: Obx(
          () => AppButton(
            text: "LogOut",
            onPressed: authController.logout,
            isLoading: authController.isLoading,
          ),
        ),
      ),
      const Center(child: Text("Favorites")),
      const Center(child: Text("Bookings")),
      const Center(child: Text("Profile")),
    ];

    final List<NavItem> navItems = [
      NavItem(icon: Assets.icons.home, label: "Home"),
      NavItem(icon: Assets.icons.search, label: "Search"),
      NavItem(icon: Assets.icons.heart, label: "Favorites"),
      NavItem(icon: Assets.icons.booking, label: "Bookings"),
      NavItem(icon: Assets.icons.person, label: "Profile"),
    ];

    return Scaffold(
      body: Obx(() => screens[currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNav(
          items: navItems,
          currentIndex: currentIndex.value,
          onTap: (i) => currentIndex.value = i,
        ),
      ),
    );
  }
}
