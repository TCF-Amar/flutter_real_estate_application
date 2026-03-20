import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/app_constants.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceRequestScreen extends GetView<MaintenanceController> {
  final int? propertyId;
  final String? propertyTitle;
  final bool? isEnable;
  const MaintenanceRequestScreen({
    super.key,
    this.propertyId,
    this.propertyTitle,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<MyBookingController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultAppBar(title: "Report an Issue", actions: []),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
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
                  const SizedBox(height: 15),
                  AppText(
                    "Title",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  AppTextFormField(
                    onChanged: (value) => controller.title.value = value,
                    hintText: "Title",
                    containerColor: Colors.transparent,

                    containerBorderColor: AppColors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 15),
                  AppText(
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
                      controller.category.value = AppConstants
                          .maintenanceCategories
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
                  AppText(
                    "Message",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  AppTextFormField(
                    hintText: "Please describe your Issue in detail",
                    maxLines: 5,
                    containerColor: Colors.transparent,
                    containerBorderColor: AppColors.grey.withValues(alpha: 0.3),
                    onChanged: (value) => controller.message.value = value,
                  ),
                  const SizedBox(height: 15),
                  AppText(
                    "Upload Image/Videos (Optional)",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.pickedMedia.isEmpty) {
                      return _buildUploadPlaceholder(context);
                    }
                    return _buildMediaList();
                  }),
                  const SizedBox(height: 20),
                  AppButton(
                    text: "Send request",
                    onPressed: () {
                      controller.sendMaintenanceRequest();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickMedia(context),
      child: AppContainer(
        width: double.infinity,
        showBorder: false,
        padding: const EdgeInsets.all(24),
        border: DashedBorder.fromBorderSide(
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.5),
            width: 1.5,
          ),
          dashLength: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(path: Assets.icons.upload, width: 32, height: 32),
            const SizedBox(height: 12),
            AppText(
              "Tap to Upload Image or Videos",
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            AppText.small(
              "Supported Image: .jpg, .jpeg, .png",
              color: AppColors.textTertiary,
            ),
            AppText.small(
              "Supported Video: .mp4",
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaList() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.pickedMedia.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == controller.pickedMedia.length) {
                return _buildAddMoreButton(context);
              }
              final file = controller.pickedMedia[index];
              final isVideo = file.path.toLowerCase().endsWith('.mp4');

              return Stack(
                children: [
                  AppContainer(
                    width: 100,
                    height: 100,
                    clipContent: true,
                    borderRadius: BorderRadius.circular(12),
                    child: isVideo
                        ? Container(
                            color: AppColors.black.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.videocam,
                              color: AppColors.grey,
                            ),
                          )
                        : Image.file(file, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => controller.removeMedia(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickMedia(context),
      child: AppContainer(
        width: 100,
        height: 100,
        showBorder: false,
        border: DashedBorder.fromBorderSide(
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.5),
            width: 1.5,
          ),
          dashLength: 5,
        ),
        child: const Icon(Icons.add, color: AppColors.grey),
      ),
    );
  }
}
