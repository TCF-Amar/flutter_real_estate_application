import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/explore/views/widgets/agents_view.dart';
import 'package:real_estate_app/features/explore/views/widgets/developers_view.dart';
import 'package:real_estate_app/features/property/views/screens/property_screen.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Projects", "Agents", "Developers"];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        centerTitle: true,
        title: HeaderText(text: "Explore"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Custom Tab Toggle
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary),
              ),
              child: Stack(
                children: [
                  Obx(() {
                    return AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment(
                        -1.0 + (controller.selectedTabIndex.value * 1.0),
                        0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 1 / 3,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
                  Row(
                    children: List.generate(tabs.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(index),
                          behavior: HitTestBehavior.opaque,
                          child: Center(
                            child: Obx(
                              () => AppText(
                                tabs[index],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color:
                                    controller.selectedTabIndex.value == index
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Search Bar & Filter

            // Content Views
            Expanded(
              child: Obx(() {
                // Only show empty state if not loading and no data found

                switch (controller.selectedTabIndex.value) {
                  case 0:
                    return const PropertyScreen();
                  case 1:
                    return const AgentsView();
                  case 2:
                    return const DevelopersView();
                  default:
                    return const Center(child: Text("Unknown Tab"));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
