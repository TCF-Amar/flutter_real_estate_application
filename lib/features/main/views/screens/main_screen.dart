import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/main/controllers/main_controller.dart';
import 'package:real_estate_app/features/main/views/widgets/bottom_nav.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
