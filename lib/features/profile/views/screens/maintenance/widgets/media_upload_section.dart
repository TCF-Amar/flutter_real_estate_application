import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MediaUploadSection extends GetView<MaintenanceController> {
  const MediaUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Upload Image/Videos (Optional)",
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.pickedMedia.isEmpty) {
            return _UploadPlaceholder();
          }
          return _MediaList();
        }),
      ],
    );
  }
}

class _UploadPlaceholder extends GetView<MaintenanceController> {
  @override
  Widget build(BuildContext context) {
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
}

class _MediaList extends GetView<MaintenanceController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.pickedMedia.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == controller.pickedMedia.length) {
            return _AddMoreButton();
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
    );
  }
}

class _AddMoreButton extends GetView<MaintenanceController> {
  @override
  Widget build(BuildContext context) {
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
