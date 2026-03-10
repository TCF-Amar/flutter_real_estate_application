import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/property_card.dart';

/// Redesigned "Recommended for You" section featuring filter categories
/// and vertically stacked detailed property cards.
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AppText(
            'Recommended for You',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black.withValues(alpha: 0.8),
          ),
        ),

        // Filter chips — isolated StatefulWidget so only chips row rebuilds
        _FilterChipRow(controller: controller),

        const SizedBox(height: 16),

        // Property cards — Obx only wraps these cards
        Obx(() {
          if (controller.isLoading.value &&
              controller.recommendedProperties.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final properties = controller.recommendedProperties;
          if (properties.isEmpty) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: AppText(
                  'No properties found in this category',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Column instead of shrinkWrap ListView so Flutter doesn't
          // eagerly measure all cards before the scroll view renders.
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                for (int i = 0; i < properties.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  PropertyCard(
                    property: properties[i],
                    featured: true,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.propertyDetails,
                        arguments: {'id': properties[i].id},
                      );
                    },
                    onFavoriteTap: () {
                      controller.toggleFavoriteProperty(
                        propertyId: properties[i].id,
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _FilterChipRow extends StatefulWidget {
  final HomeController controller;
  const _FilterChipRow({required this.controller});

  @override
  State<_FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<_FilterChipRow> {
  static const _filters = ['All', 'For Sale', 'For Rent', 'Nearby'];
  int _activeFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _activeFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _activeFilterIndex = index);
              widget.controller.filterProperties(_filters[index]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: AppText(
                  _filters[index],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
