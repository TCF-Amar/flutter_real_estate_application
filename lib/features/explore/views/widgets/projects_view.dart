import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/property_card.dart';
import 'package:real_estate_app/features/shared/widgets/property_skeleton.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController exploreController = Get.find<ExploreController>();

    return Obx(() {
      if (exploreController.isLoading) {
        return ListView.separated(
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => const PropertySkeleton(),
        );
      }

      return ListView.separated(
        controller: exploreController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: 2 +
            (exploreController.filteredProperties.isEmpty
                ? 1
                : exploreController.filteredProperties.length +
                    (exploreController.currentPage.value <
                            exploreController.lastPage.value
                        ? 1
                        : 0)),
        separatorBuilder: (context, index) {
          if (index == 0) return const SizedBox(height: 16);
          if (exploreController.filteredProperties.isEmpty && index == 1) {
            return const SizedBox(height: 16);
          }
          if (index <= exploreController.filteredProperties.length) {
            return const SizedBox(height: 16);
          }
          return const SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            // Filter Header
            return SizedBox(
              height: 32,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                scrollDirection: Axis.horizontal,
                itemCount: exploreController.propertyFilters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, filterIndex) {
                  final isSelected =
                      exploreController.selectedPropertyFilterIndex.value ==
                      filterIndex;
                  return GestureDetector(
                    onTap: () {
                      exploreController.changePropertyFilter(filterIndex);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        exploreController.propertyFilters[filterIndex],
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // Properties or Empty State
          if (exploreController.filteredProperties.isEmpty) {
            if (index == 1) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: AppText(
                    "No properties found for this category",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }
          } else if (index <= exploreController.filteredProperties.length) {
            final propertyIndex = index - 1;
            return PropertyCard(
              item: exploreController.filteredProperties[propertyIndex],
              onTap: () {
                // Navigate to details
              },
            );
          }

          // Footer
          if (exploreController.isMoreLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: PropertySkeleton()),
            );
          }

          if (exploreController.currentPage.value >=
                  exploreController.lastPage.value &&
              exploreController.filteredProperties.isNotEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: AppText(
                  "No more properties available",
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
    });
  }
}
