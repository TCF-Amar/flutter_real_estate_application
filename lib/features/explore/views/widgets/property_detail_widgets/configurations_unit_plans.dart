import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/property_unit.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class ConfigurationsUnitPlans extends StatelessWidget {
  final List<PropertyUnit> units;
  const ConfigurationsUnitPlans({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Configurations & Unit Plans"),
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 8),
          ...units.map((unit) => _buildUnitRow(unit)),

          const SizedBox(height: 20),
          HeaderText(text: "Floor plan"),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: units
                  .map(
                    (u) => Container(
                      height: 200,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _headerCell("Configuration")),
          Expanded(flex: 2, child: _headerCell("Size")),
          Expanded(flex: 3, child: _headerCell("Price")),
          Expanded(flex: 3, child: _headerCell("Availability")),
          Expanded(
            flex: 4,
            child: _headerCell("Action", textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {TextAlign textAlign = TextAlign.start}) {
    return AppText(
      text,
      fontSize: 12,
      // fontWeight: FontWeight.bold,
      color: AppColors.grey,
      textAlign: textAlign,
    );
  }

  Widget _buildUnitRow(PropertyUnit unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Configuration Type
          Expanded(
            flex: 3,
            child: AppText(
              "${unit.floor ?? "N/A"} ",
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Size
          Expanded(
            flex: 2,
            child: AppText(
              unit.areaSqft != null
                  ? "${unit.areaSqft!.toStringAsFixed(0)} Sqft"
                  : "N/A",
              fontSize: 10,
              color: AppColors.black.withValues(alpha: 0.7),
            ),
          ),
          // Price
          Expanded(
            flex: 3,
            child: AppText(
              unit.formattedPrice ?? "Contact",
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          // Availability
          Expanded(
            flex: 3,
            child: AppText(
              "Few Left",
              fontSize: 10,
              color: AppColors.black.withValues(alpha: 0.7),
            ),
          ),
          // Action Button
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: AppColors.primary, width: 1),
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  child: const AppText(
                    "View Plans",
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlanCard(String? imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 200,
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
