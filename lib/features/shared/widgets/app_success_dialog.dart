import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AppSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onDone;

  const AppSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = "Done.",
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //? Success Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 24),

            //? Title Text
            AppText(
              title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            const SizedBox(height: 12),

            //? Message
            AppText(
              message,
              fontSize: 14,
              color: AppColors.grey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            //? Done Button
            AppButton(
              text: buttonText,
              backgroundColor: Colors.green.withValues(alpha: 0.05),
              textColor: Colors.green,
              showShadow: false,
              borderRadius: 16,
              onPressed: onDone ?? () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
