import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/location_permission_util.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

Future<void> showLocationDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppText.large("Enable ", color: Colors.green),
                  AppText.large("Location Access"),
                ],
              ),

              const SizedBox(height: 12),

              const AppText(
                "Allow location access to find properties near you and personalize your experience. You can change this anytime in your app settings.",
                textAlign: TextAlign.start,
                fontSize: 12,
                overflow: TextOverflow.clip,
                color: AppColors.textSecondary,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Maybe later",
                      onPressed: () => Get.back(),
                      isBorder: true,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      fontSize: 14,
                      textColor: AppColors.textSecondary,
                      showShadow: false,
                      backgroundColor: AppColors.white,
                      borderColor: AppColors.textSecondary.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    // OutlinedButton(
                    //   onPressed: () {
                    //     Get.back();
                    //   },
                    //   child: const AppText("Maybe later"),
                    // ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: AppButton(
                      text: "Allow",
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      fontSize: 14,

                      onPressed: () async {
                        await LocationPermissionUtil.requestPermission();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
