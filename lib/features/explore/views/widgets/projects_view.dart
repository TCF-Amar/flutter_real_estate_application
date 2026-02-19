import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/property_card.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController exploreController = Get.find<ExploreController>();
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      children: [
        // Filter Chips
        SizedBox(
          height: 32,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            scrollDirection: Axis.horizontal,
            itemCount: exploreController.propertyFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return Obx(() {
                final isSelected =
                    exploreController.selectedPropertyFilterIndex.value ==
                    index;
                return GestureDetector(
                  onTap: () {
                    exploreController.changePropertyFilter(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey?.withValues(alpha: 0.3) ??
                                  Colors.grey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      exploreController.propertyFilters[index],
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        // Listing
        Expanded(
          child: Obx(() {
            if (homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final properties =
                homeController.featuredProperties; // Using featured for demo
            if (properties.isEmpty) {
              return const Center(child: Text("No properties found"));
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: properties.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return PropertyCard(
                  item: properties[index],
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
