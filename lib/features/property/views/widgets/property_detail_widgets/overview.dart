import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class Overview extends StatelessWidget {
  final PropertyDetail property;
  const Overview({super.key, required this.property});

  String _formatArea(num? area) {
    if (area == null || area == 0) return "N/A";
    return "${area.toStringAsFixed(0)} Sqft";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Overview",
            // fontSize: 16,
            // fontWeight: FontWeight.bold,
            // color: AppColors.black.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: property.isProject
                ? _buildProjectOverview()
                : _buildPropertyOverview(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverview() {
    final items = [
      _OverviewItem(
        label: "Property Type",
        value: property.propertyCategory?.capitalize ?? 'N/A',
      ),
      _OverviewItem(
        iconPath: Assets.icons.tower,
        label: "Tower",
        value: "${property.totalTowers ?? 'N/A'}",
      ),
      _OverviewItem(
        iconPath: Assets.icons.unit,
        label: "Units",
        value: "${property.totalUnits ?? 'N/A'}",
      ),
      _OverviewItem(
        iconPath: Assets.icons.flor,
        label: "Floors",
        value: _formatArea(property.totalFloors),
      ),
      _OverviewItem(
        iconPath: Assets.icons.calender,
        label: "Year Built",
        value: property.yearBuilt?.toString() ?? "N/A",
      ),
      _OverviewItem(
        iconPath: Assets.icons.area,
        label: "Area",
        value: property.buildingAreaSqft?.toString() ?? "N/A",
      ),
    ];

    return _buildGrid(items);
  }

  Widget _buildPropertyOverview() {
    final items = [
      _OverviewItem(
        // icon: Icons.chair,
        label: "Property Type",
        value: property.propertyCategory?.capitalize ?? 'N/A',
      ),
      _OverviewItem(
        icon: Icons.bed_outlined,
        label: "Bedrooms",
        value: property.bhkList?.toString() ?? "N/A",
      ),
      _OverviewItem(
        icon: Icons.bathroom_outlined,
        label: "Bathrooms",
        value: property.bathroomList?.toString() ?? "N/A",
      ),
      _OverviewItem(
        icon: Icons.garage_outlined,
        label: "Garage",
        value: property.parkingOpenCount?.toString() ?? "0",
      ),
      _OverviewItem(
        iconPath: Assets.icons.calender,
        label: "Year Built",
        value: property.yearBuilt?.toString() ?? "N/A",
      ),
      _OverviewItem(
        iconPath: Assets.icons.area,
        label: "Built",
        value: property.buildingAreaSqft?.toString() ?? "N/A",
      ),
    ];

    return _buildGrid(items);
  }

  Widget _buildGrid(List<_OverviewItem> items) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 0,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, color: AppColors.grey, size: 22),
              const SizedBox(width: 8),
            ],
            if (item.iconPath != null) ...[
              SvgPicture.asset(
                item.iconPath!,
                // colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.value.toString().split("_").join(" "),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    // maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    item.label,
                    fontSize: 10,
                    color: AppColors.grey,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewItem {
  final IconData? icon;
  final String? iconPath;
  final String label;
  final String value;

  _OverviewItem({
    this.icon,
    this.iconPath,
    required this.label,
    required this.value,
  });
}
