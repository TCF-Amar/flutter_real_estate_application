import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

void showRequestSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.white,
        content: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const AppText(
                "Support Request Send",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textAlign: .start,
              ),
              const SizedBox(height: 12),
              const AppText(
                "Our team has received your query. You’ll get a response within 24 hours",
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Close",
                  fontSize: 12,
                  backgroundColor: AppColors.white,
                  isBorder: true,
                  borderColor: AppColors.grey,
                  showShadow: false,
                  textColor: AppColors.textPrimary,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  text: "View Request",
                  fontSize: 12,
                  onPressed: () {
                    Get.back();
                    AppSnackbar.info("Not implement yet!");
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
