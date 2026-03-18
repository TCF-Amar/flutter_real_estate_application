import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedUnits extends StatelessWidget {
  final BookedPropertyDetail property;
  const BookedUnits({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final unit = property.unitDetails;
    final List<Map<String, dynamic>> items = [
      {
        'icon': null,
        'label': 'Type',
        'value': property.propertyCategory ?? 'N/A',
      },
      {
        'icon': Assets.icons.bed,
        'label': 'BHK',
        'value': unit?.bhk?.toString() ?? 'N/A',
      },
      {
        'icon': Assets.icons.tower,
        'label': 'Tower',
        'value': unit?.block ?? 'N/A',
      },
      {
        'icon': Assets.icons.flor,
        'label': 'Floor',
        'value': unit?.floor ?? 'N/A',
      },
      {
        'icon': Assets.icons.unit,
        'label': 'Flat No.',
        'value': unit?.unitNumber ?? 'N/A',
      },

      {
        'icon': Assets.icons.area,
        'label': 'Area',
        'value': unit?.size ?? 'N/A',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(
          "Selected Unit",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),
        AppContainer(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          color: AppColors.grey.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          child: GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: items.map((item) => _buildUnitItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitItem(Map<String, dynamic> item) {
    return Row(
      children: [
        if (item['icon'] != null)
          AppSvg(
            path: item['icon'],
            color: AppColors.grey,
            height: 18,
            width: 18,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                "${item['value']}".capitalizeFirst ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 2),
              AppText(
                item['label'],
                fontSize: 11,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
