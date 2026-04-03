import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/services/deep_link_service.dart';
import 'package:real_estate_app/features/main/controllers/main_controller.dart';
import 'package:real_estate_app/features/main/views/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // The app has fully started and the navigation stack is ready (splash →
    // auth → main). Now it's safe to consume any cold-start deep link URI.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DeepLinkService>().consumePending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNav(
          items: controller.navItems,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}
