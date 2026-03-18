import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/search/controllers/search_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SearchResult extends StatelessWidget {
  final controller = Get.find<AppSearchController>();
  SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// MAP BACKGROUND
            AppContainer(
              height: Get.height,
              child: Image.asset(Assets.images.map, fit: BoxFit.cover),
            ),

            /// SEARCH BAR OVER MAP
            Positioned(
              top: 20,
              left: 18,
              right: 18,
              child: AppContainer(
                height: 50,
                alignment: Alignment.center,
                showBorder: true,
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                borderColor: AppColors.grey.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                    ),
                    Expanded(
                      child: AppText(
                        controller.query.isEmpty
                            ? "Properties"
                            : controller.query.capitalizeFirst!,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// DRAGGABLE RESULTS SHEET
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: controller.properties.length > 1 ? 0.85 : 0.6,
              snap: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                    return AppContainer(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Center(
                            child: AppContainer(
                              width: 40,
                              height: 5,
                              color: AppColors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// HEADER: TITLE + CLOSE
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  controller.query.isEmpty
                                      ? "Properties"
                                      : controller.query.capitalizeFirst!,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                IconButton(
                                  onPressed: () => Get.back(),
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// FILTERS & RESULTS
                          Expanded(
                            child: Obx(() {
                              if (controller.properties.isEmpty &&
                                  !controller.isLoading) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 80,
                                        color: AppColors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const AppText(
                                        "No properties found",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                      const SizedBox(height: 8),
                                      AppText(
                                        "Try adjusting your filters or search terms",
                                        fontSize: 14,
                                        color: AppColors.grey,
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: 200,
                                        child: AppButton(
                                          text: "Back to Search",
                                          onPressed: () => Get.back(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// FILTER PILLS
                                  Row(
                                    children: [
                                      _buildFilterPill(
                                        title: "All",
                                        isSelected:
                                            controller.selectedListingCategory ==
                                            null,
                                        onTap:
                                            () => controller
                                                .updateListingCategory(null),
                                      ),
                                      _buildFilterPill(
                                        title: "For Sale",
                                        isSelected:
                                            controller.selectedListingCategory ==
                                            'for_sale',
                                        onTap:
                                            () => controller
                                                .updateListingCategory(
                                                  'for_sale',
                                                ),
                                      ),
                                      _buildFilterPill(
                                        title: "For Rent",
                                        isSelected:
                                            controller.selectedListingCategory ==
                                            'for_rent',
                                        onTap:
                                            () => controller
                                                .updateListingCategory(
                                                  'for_rent',
                                                ),
                                      ),
                                      _buildFilterPill(
                                        title: "Sort By",
                                        icon: Icons.unfold_more_rounded,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  /// RESULTS LIST
                                  Expanded(
                                    child: NotificationListener<
                                      ScrollNotification
                                    >(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                            if (scrollInfo.metrics.pixels >=
                                                scrollInfo.metrics
                                                        .maxScrollExtent -
                                                    200) {
                                              controller.searchMore();
                                            }
                                            return true;
                                          },
                                      child: ListView.separated(
                                        controller: scrollController,
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          0,
                                          20,
                                          20,
                                        ),
                                        itemCount:
                                            controller.properties.length +
                                            (controller.hasNextPage ? 1 : 0),
                                        separatorBuilder:
                                            (context, index) =>
                                                const SizedBox(height: 16),
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              controller.properties.length) {
                                            return controller.isLoading
                                                ? const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                                : const SizedBox.shrink();
                                          }
                                          final property =
                                              controller.properties[index];
                                          return ModernPropertyCard(
                                            property: property,
                                            onToggleFavorite:
                                                () =>
                                                    controller.toggleFavorite(
                                                      property,
                                                    ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String title,
    bool isSelected = false,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? null
              : Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title,
              color: isSelected ? AppColors.white : AppColors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.white : AppColors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
