import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/services/profile_services.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

void showOtpDialog(String fieldType, String targetValue) {
  final otpController = TextEditingController();
  final isVerifying = false.obs;

  // final authServices = Get.find<AuthServices>();

  final controller = Get.find<ProfileController>();
  final services = Get.find<ProfileServices>();

  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          AppText(
            "Verify",
            fontSize: 16,
            fontWeight: .bold,
            color: AppColors.primary,
          ),
          AppText(
            ' ${fieldType.capitalizeFirst}',
            fontSize: 16,
            fontWeight: .bold,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              AppText(
                'We\'ve sent a 6-digit code to ',
                overflow: .clip,
                fontSize: 14,
              ),
              AppText(
                targetValue,
                overflow: .clip,
                fontSize: 14,
                // fontWeight: .bold,
                color: AppColors.primary,
              ),
              AppText(
                'Please enter it below to verify.',
                overflow: .clip,
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Enter 6-digit OTP',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        Obx(
          () => ElevatedButton(
            onPressed: isVerifying.value
                ? null
                : () async {
                    final otp = otpController.text.trim();
                    if (otp.length != 6) {
                      AppSnackbar.error('Please enter a valid 6-digit OTP');
                      return;
                    }

                    isVerifying.value = true;
                    final result = await services.verifyChangeOtp(
                      fieldType,
                      targetValue,
                      otp,
                    );
                    isVerifying.value = false;

                    result.fold(
                      (failure) => AppSnackbar.error(failure.message),
                      (success) {
                        AppSnackbar.success(
                          '${fieldType.capitalizeFirst} verified!',
                        );
                        Get.back();
                        controller.markFieldAsVerifiedLocally(
                          fieldType,
                          targetValue,
                        );
                      },
                    );
                  },
            child: isVerifying.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verify'),
          ),
        ),
      ],
    ),
  );
}
