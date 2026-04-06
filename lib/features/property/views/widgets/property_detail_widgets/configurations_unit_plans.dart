import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/price_formatter.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_unit_model.dart';
import 'package:real_estate_app/features/property/views/widgets/property_detail_widgets/view_plan.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ConfigurationsUnitPlans extends StatelessWidget {
  const ConfigurationsUnitPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyDetailsController controller =
        Get.find<PropertyDetailsController>();

    final units = controller.propertyDetail?.units ?? [];

    if (units.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.large("Configurations & Unit Plans"),
          const SizedBox(height: 16),

          /// TABLE
          _buildTable(units),

          const SizedBox(height: 25),

          /// FLOOR PLAN
          AppText.large("Floor plan"),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: units
                  .map(
                    (u) => SizedBox(
                      height: 150,
                      child: _buildFloorPlanCard(
                        u.floorPlanImage,
                        unit: u,
                        context: context,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          /// VIEW FULL PLAN BUTTON
          AppButton(
            text: "View All Plans",
            onPressed: () => _openUnitSelector(context, units),
            backgroundColor: Colors.transparent,
            textColor: AppColors.primary,
            showShadow: false,
            isBorder: true,
            borderColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          ),
        ],
      ),
    );
  }

  /// ================= TABLE =================
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
          /// HEADER
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

          /// DATA ROWS
          ...units.map((unit) {
            return TableRow(
              children: [
                _tableCell(unit.unitNumber ?? "N/A"),

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
                          PriceFormatter.formatRange(property.priceRange ?? ''),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        )
                      : AppText(
                          PriceFormatter.format(unit.price ?? 0),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                ),

                _tableCell(
                  ((unit.availableUnits ?? 0) >= 5)
                      ? '${unit.availableUnits}'
                      : 'Few Left',
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
                      onTap: () => _openPlan(unit),
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

  /// ================= TABLE CELL =================
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
        child: AppText(text, fontSize: size, fontWeight: weight, color: color),
      ),
    );
  }

  /// ================= FLOOR CARD =================
  Widget _buildFloorPlanCard(
    String? imageUrl, {
    required PropertyUnitModel unit,
    required BuildContext context,
  }) {
    final imageTypePdf = imageUrl?.endsWith('.pdf') ?? false;
    return GestureDetector(
      onTap: () => _openPlan(unit),
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageTypePdf
              ? Icon(Icons.picture_as_pdf, size: 50)
              : AppImage(path: imageUrl),
        ),
      ),
    );
  }

  /// ================= OPEN PLAN =================
  void _openPlan(PropertyUnitModel unit) {
    showDialog(
      context: Get.context!,
      builder: (_) => ViewPlan(unit: unit),
    );
  }

  /// ================= SELECTOR =================
  void _openUnitSelector(BuildContext context, List<PropertyUnitModel> units) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AppContainer(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              AppContainer(
                height: 4,
                width: 50,
                color: AppColors.grey.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              AppText.large("Select Unit"),
              Divider(),
              ListView(
                shrinkWrap: true,
                children: units.map((unit) {
                  return ListTile(
                    title: Text("${unit.bhk ?? '•'} ${unit.unitNumber ?? ''}"),
                    subtitle: Text(
                      "₹${unit.price ?? '-'} • ${unit.areaSqft ?? '-'} sqft",
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _openPlan(unit);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
