import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/agent/view/screens/agents_screen.dart';
import 'package:real_estate_app/features/developer/view/screens/developers_view.dart';
import 'package:real_estate_app/features/property/views/screens/property_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Projects", "Agents", "Developers"];

    return DefaultTabController(
      length: tabs.length,
      initialIndex: controller.selectedTabIndex.value,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
          centerTitle: true,
          title: AppText.large("Explore"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 55,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: TabBar(
                  onTap: (index) => controller.changeTab(index),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Content Views
              Expanded(
                child: Obx(() {
                  // Only show empty state if not loading and no data found

                  switch (controller.selectedTabIndex.value) {
                    case 0:
                      return const PropertyScreen();
                    case 1:
                      return const AgentsScreen();
                    case 2:
                      return const DevelopersView();
                    default:
                      return const Center(child: AppText("Unknown Tab"));
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
