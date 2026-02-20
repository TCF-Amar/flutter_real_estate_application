import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProjectFilterSheet extends StatelessWidget {
  const ProjectFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController controller = Get.find();
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                'Filter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  Obx(
                    () => _buildSectionHeader(
                      'Price Range',
                      '\$${controller.maxPrice.value.toInt()}',
                    ),
                  ),
                  Obx(
                    () => SfSlider(
                      min: 0,
                      max: 100000000,

                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withValues(alpha: 0.2),
                      value: controller.maxPrice.value,
                      onChanged: (value) {
                        controller.maxPrice.value = value;
                      },
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText('\$0', color: Colors.grey, fontSize: 12),
                      AppText(
                        '\$10,00,00,000',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // BHK
                  const AppText(
                    'Bedroom/BHK',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final filterData = controller.filterData.value?.data;
                    if (filterData == null) return const SizedBox();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filterData.bhkOptions.map((bhk) {
                        final label = bhk.label;
                        final isSelected = controller.selectedBhk.contains(
                          bhk.value,
                        );
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedBhk.add(bhk.value);
                            } else {
                              controller.selectedBhk.remove(bhk.value);
                            }
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          showCheckmark: false,
                          avatar: isSelected
                              ? const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Area
                  Obx(
                    () => _buildSectionHeader(
                      'Area',
                      '${controller.minArea.value.toInt()} - ${controller.maxArea.value.toInt()} Sq. Ft.',
                    ),
                  ),
                  Obx(
                    () => SfSlider(
                      min: 0,
                      max: 10000,
                      value: controller.maxArea.value.toDouble(),
                      onChanged: (value) {
                        controller.maxArea.value = value.toInt();
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText('0 Sq. Ft.', color: Colors.grey, fontSize: 12),
                      AppText(
                        '10000 Sq. Ft.',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  const AppText(
                    'Amenities',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final filterData = controller.filterData.value?.data;
                    if (filterData == null) return const SizedBox();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filterData.amenities.map((amenity) {
                        final isSelected = controller.selectedAmenities.value
                            .contains(amenity);
                        return ChoiceChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            controller.selectedAmenities.value = selected
                                ? amenity
                                : '';
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          showCheckmark: false,
                          avatar: isSelected
                              ? const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Status
                  const AppText(
                    'Status',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final filterData = controller.filterData.value?.data;
                    if (filterData == null ||
                        filterData.listingCategories == null) {
                      return const SizedBox();
                    }
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownFlutter(
                          hintText: 'Select Status',
                          items: filterData.listingCategories!.keys.toList(),
                          initialItem:
                              controller.selectedListingCategories.value.isEmpty
                              ? null
                              : controller.selectedListingCategories.value,
                          onChanged: (value) {
                            controller.selectedListingCategories.value = value!;
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Sort By
                  const AppText(
                    'Sort By',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final filterData = controller.filterData.value?.data;
                    if (filterData == null) return const SizedBox();
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownFlutter(
                          hintText: 'Select Sort',
                          items: filterData.sortOptions.values.toList(),
                          initialItem: controller.selectedSort.value,
                          onChanged: (value) {
                            controller.selectedSort.value = value;
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Footer
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText('Reset', color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText('Apply', color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, fontSize: 16, fontWeight: FontWeight.w600),
        if (value != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppText(value, fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}
