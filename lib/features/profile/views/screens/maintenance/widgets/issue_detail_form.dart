import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/app_constants.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class IssueDetailForm extends GetView<MaintenanceController> {
  const IssueDetailForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Title",
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          onChanged: (value) => controller.title.value = value,
          hintText: "Title",
          // color: Colors.transparent,
          borderColor: AppColors.grey.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 15),
        const AppText(
          "Subject/issue",
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        DropdownFlutter.search(
          items: AppConstants.maintenanceCategories
              .map((e) => e.values.first)
              .toList(),
          hintText: "Select",
          onChanged: (value) {
            controller.category.value = AppConstants.maintenanceCategories
                .firstWhere((e) => e.values.first == value)
                .keys
                .first
                .toLowerCase();
          },
          decoration: CustomDropdownDecoration(
            closedBorder: Border.all(
              color: AppColors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
            closedBorderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 15),
        const AppText(
          "Message",
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        AppTextFormField(
          hintText: "Please describe your Issue in detail",
          maxLines: 5,
          // containerColor: Colors.transparent,
          borderColor: AppColors.grey.withValues(alpha: 0.3),
          onChanged: (value) => controller.message.value = value,
        ),
      ],
    );
  }
}
