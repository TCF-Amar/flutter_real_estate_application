import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertySelectDropdown extends GetView<MaintenanceController> {
  final int? propertyId;
  final String? propertyTitle;

  const PropertySelectDropdown({
    super.key,
    this.propertyId,
    this.propertyTitle,
  });

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<MyBookingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Property Name",
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        Obx(
          () => DropdownFlutter.search(
            enabled: propertyId == null,
            hintText: propertyTitle ?? "Select Property",
            items: [...bookingController.bkpl.map((e) => e.title)],
            onChanged: (value) {
              controller.pid.value = bookingController.bkpl
                  .firstWhere((e) => e.title == value)
                  .pid;
            },
            decoration: CustomDropdownDecoration(
              closedBorder: Border.all(
                color: AppColors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
              closedBorderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
