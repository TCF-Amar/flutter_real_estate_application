import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/property_card.dart';

/// Redesigned "Recommended for You" section featuring filter categories
/// and vertically stacked detailed property cards.
class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  int _activeFilterIndex = 0;
  final List<String> _filters = ['All', 'For Sale', 'For Rent', 'Nearby'];
  final HomeController _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Recommended for You',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),

        // Filter Categories
        SizedBox(
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
                  _controller.filterProperties(_filters[index]);
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
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Scrollable Property Cards
        Obx(() {
          if (_controller.isLoading.value &&
              _controller.recommendedProperties.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final properties = _controller.recommendedProperties;
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

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: properties.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) =>
                PropertyCard(item: properties[index]),
          );
        }),

        const SizedBox(height: 20),
      ],
    );
  }
}
