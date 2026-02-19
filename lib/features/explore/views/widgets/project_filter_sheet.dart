import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class ProjectFilterSheet extends StatefulWidget {
  const ProjectFilterSheet({super.key});

  @override
  State<ProjectFilterSheet> createState() => _ProjectFilterSheetState();
}

class _ProjectFilterSheetState extends State<ProjectFilterSheet> {
  final ExploreController controller = Get.find();

  RangeValues _priceRange = const RangeValues(0, 10000000);
  RangeValues _areaRange = const RangeValues(1800, 8000);
  final List<String> _selectedBhk = [];
  final List<String> _selectedAmenities = [];
  String? _selectedStatus;
  String? _selectedSort;

  @override
  Widget build(BuildContext context) {
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
      child: Obx(() {
        final filterData = controller.filterData.value?.data;

        if (filterData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
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
                    _buildSectionHeader(
                      'Price Range',
                      '\$${_priceRange.start.toInt()}',
                      '\$${_priceRange.end.toInt()}',
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 100000000,
                      divisions: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withValues(alpha: 0.2),
                      onChanged: (values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText('\$0', color: Colors.grey, fontSize: 12),
                        AppText('10 Cr+', color: Colors.grey, fontSize: 12),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filterData.bhkOptions.map((bhk) {
                        final label = bhk.label;
                        final isSelected = _selectedBhk.contains(label);
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedBhk.add(label);
                              } else {
                                _selectedBhk.remove(label);
                              }
                            });
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
                    ),
                    const SizedBox(height: 24),

                    // Area
                    _buildSectionHeader(
                      'Area',
                      '${_areaRange.start.toInt()} Sq. Ft.',
                      '${_areaRange.end.toInt()} Sq. Ft.',
                    ),
                    RangeSlider(
                      values: _areaRange,
                      min: 0,
                      max: 10000,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withValues(alpha: 0.2),
                      onChanged: (values) {
                        setState(() {
                          _areaRange = values;
                        });
                      },
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filterData.amenities.map((amenity) {
                        final isSelected = _selectedAmenities.contains(amenity);
                        return ChoiceChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
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
                    ),
                    const SizedBox(height: 24),

                    // Status
                    const AppText(
                      'Status',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select'),
                          value: _selectedStatus,
                          items: filterData.propertyTypes.values.map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sort By
                    const AppText(
                      'Sort By',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select'),
                          value: _selectedSort,
                          items: filterData.sortOptions.values.map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSort = newValue;
                            });
                          },
                        ),
                      ),
                    ),
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
                      setState(() {
                        _priceRange = const RangeValues(0, 10000000);
                        _areaRange = const RangeValues(0, 10000);
                        _selectedBhk.clear();
                        _selectedAmenities.clear();
                        _selectedStatus = null;
                        _selectedSort = null;
                      });
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
                      Navigator.pop(context);
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
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, String? value1, [String? value2]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, fontSize: 16, fontWeight: FontWeight.w600),
        if (value1 != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppText(
              value2 != null ? value1 : value1,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
