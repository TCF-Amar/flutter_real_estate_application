import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/views/widgets/empty_explore.dart';
import 'package:real_estate_app/features/property/views/widgets/property_filters.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyScreen extends GetView<PropertyController> {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshProperties(),
      child: Obx(() {
        final isLoading = controller.isLoading;
        final isMoreLoading = controller.isMoreLoading;
        final selectedIndex = controller.selectedIndex.value;
        final properties = controller.filteredProperties;
        final filters = controller.propertyFilters;
        final hasMore =
            controller.currentPage.value < controller.lastPage.value;
        final error = controller.error;

        if (error != null) {
          return EmptyExplore(
            refreshFun: () => controller.refreshProperties(),
            resetFun: () => controller.resetFilters(),
            error: error.message,
            type: 'Properties',
          );
        }
        if (properties.isEmpty) {
          return EmptyExplore(
            refreshFun: () => controller.refreshProperties(),
            resetFun: () => controller.resetFilters(),
            type: 'Properties',
          );
        }

        return CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Floating Header
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 0, // We use bottom for the actual header content
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(160),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExploreSearchFilter(
                        controller: controller.searchController,
                        hintText: 'Search by project, area, or keyword',
                        onChanged: (val) => controller.searchQuery.value = val,
                        onFilterTap: () => PropertyFilters.showFilters(context),
                        handleSearch: () => controller.handleSearch(),
                      ),
                      const SizedBox(height: 16),
                      const AppText(
                        'Explore property',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 34,
                        child: ListView.separated(
                          clipBehavior: Clip.none,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.white,
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
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

            // Property List
            if (isLoading)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: PropertySkeleton(),
                    ),
                    childCount: 5,
                  ),
                ),
              )
            else if (properties.isEmpty)
              SliverFillRemaining(child: _emptyState())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == properties.length) {
                    return isMoreLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: PropertySkeleton()),
                          )
                        : const SizedBox.shrink();
                  }
                  final property = properties[index];
                  return PropertyCard(
                    
                    property: property,
                    onTap: () => Get.toNamed(
                      AppRoutes.propertyDetails,
                      arguments: {'id': property.id},
                    ),
                    onFavoriteTap: () => controller.toggleFavoriteProperty(
                      propertyId: property.id,
                    ),
                  );
                }, childCount: properties.length + (hasMore ? 1 : 0)),
              ),
          ],
        );
      }),
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                'No properties found',
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
