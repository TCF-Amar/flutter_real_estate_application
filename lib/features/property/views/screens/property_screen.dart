import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/views/widgets/property_filters.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/explore_search_filter.dart';
import 'package:real_estate_app/features/shared/widgets/property_card.dart';
import 'package:real_estate_app/features/shared/widgets/property_skeleton.dart';

class PropertyScreen extends GetView<PropertyController> {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Single top-level Obx — all reactive reads happen at the TOP of the
    // builder, not inside lazy delegates (itemBuilder, separatorBuilder).
    // This ensures GetX properly tracks every observable on each build.
    return Obx(() {
      final isLoading = controller.isLoading;
      final isMoreLoading = controller.isMoreLoading;
      final selectedIndex = controller.selectedIndex.value;
      final properties = controller.filteredProperties;
      final filters = controller.propertyFilters;
      final hasMore = controller.currentPage.value < controller.lastPage.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar + filter button ─────────────────────────────
          ExploreSearchFilter(
            controller: controller.searchController,
            hintText: 'Search by project, area, or keyword',
            onChanged: (val) => controller.searchQuery.value = val,
            onFilterTap: () => PropertyFilters.showFilters(context),
            handleSearch: () => controller.handleSearch(),
          ),
          const SizedBox(height: 16),

          // ── Section heading ────────────────────────────────────────
          const AppText(
            'Explore property',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),

          // ── Filter chips ───────────────────────────────────────────
          // selectedIndex captured above — no Obx needed, we're already in one
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, i) {
                final isSelected = selectedIndex == i;
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < filters.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => controller.changePropertyFilter(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFDDDDDD),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        filters[i],
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, i) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: PropertySkeleton(),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => controller.refreshProperties(),
                    color: AppColors.primary,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: properties.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: properties.length + (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == properties.length) {
                                // Pagination footer
                                return isMoreLoading
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: PropertySkeleton(),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }
                              final property = properties[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: PropertyCard(
                                  item: property,
                                  onTap: () => Get.toNamed(
                                    AppRoutes.propertyDetails,
                                    arguments: {'id': property.id},
                                  ),
                                  onFavoriteTap: () => controller
                                      .toggleFavorite(propertyId: property.id),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      );
    });
  }

  Widget _emptyState() {
    return ListView(
      // Wrap in ListView so RefreshIndicator's pull-to-refresh still works
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 80),
        Center(
          child: AppText(
            'No properties found',
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
