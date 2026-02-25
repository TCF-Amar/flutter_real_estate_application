import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/price_formatter.dart';
import 'package:real_estate_app/features/explore/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/explore/models/property_unit_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class ConfigurationsUnitPlans extends StatelessWidget {
  // final List<PropertyUnit> units;
  const ConfigurationsUnitPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyDetailsController controller =
        Get.find<PropertyDetailsController>();
    if (controller.propertyDetail!.units!.isEmpty) return const SizedBox();
    final units = controller.propertyDetail?.units ?? [];

    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Configurations & Unit Plans"),
          const SizedBox(height: 16),
          // Table-like view
          _buildTable(units),

          const SizedBox(height: 25),
          HeaderText(text: "Floor plan"),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: units
                  .map(
                    (u) => SizedBox(
                      height: 150,
                      child: _buildFloorPlanCard(u.floorPlanImage),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: "View Full Plan",
            onPressed: () {},
            backgroundColor: Colors.transparent,
            textColor: AppColors.primary,
            // borderWidth: 1,
            showShadow: false,
            isBorder: true,
            borderColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<PropertyUnitModel> units) {
    final controller = Get.find<PropertyDetailsController>();
    final property = controller.propertyDetail;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.08)),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(3),
          3: FlexColumnWidth(3),
          4: FlexColumnWidth(4),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.05),
            ),
            children: [
              _tableCell('Configuration', isHeader: true),
              _tableCell('Size', isHeader: true),
              _tableCell('Price', isHeader: true),
              _tableCell('Availability', isHeader: true),
              _tableCell('Action', isHeader: true, textAlign: TextAlign.right),
            ],
          ),
          // Data rows
          ...units.map((unit) {
            return TableRow(
              children: [
                _tableCell('${unit.unitNumber ?? "N/A"} '),
                _tableCell(
                  unit.areaSqft != null
                      ? '${unit.areaSqft!.toStringAsFixed(0)} Sqft'
                      : 'N/A',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: property!.isProject
                      ? AppText(
                          PriceFormatter.formatRange(
                            property.priceRange!.toString(),
                          ),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          overflow: TextOverflow.clip,
                        )
                      : AppText(
                          PriceFormatter.format(unit.price ?? 0).toString(),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                ),
                _tableCell(
                  "${unit.availableUnits! >= 5 ? unit.availableUnits : 'Few Left'}",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: const AppText(
                        'View Plans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool isHeader = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    final color = isHeader
        ? AppColors.grey
        : AppColors.black.withValues(alpha: 0.7);
    final size = isHeader ? 12.0 : 10.0;
    final weight = isHeader ? FontWeight.w600 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Align(
        alignment: textAlign == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: AppText(
          text,
          fontSize: size,
          fontWeight: weight,
          color: color,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  Widget _buildFloorPlanCard(String? imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey.withValues(alpha: 0.05),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.grey,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: AppColors.grey.withValues(alpha: 0.05),
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: AppColors.grey),
                ),
              ),
      ),
    );
  }
}
