import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

Future<bool?> showLogoutDialog(BuildContext context) {
  final AuthController authController = Get.find();
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            AppText(
              "Logout",
              color: AppColors.error,
              fontSize: 16,
              fontWeight: .bold,
            ),
          ],
        ),
        content: const AppText(
          "Are you sure you want to logout from your account?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const AppText("Cancel"),
          ),

          TextButton(
            onPressed: () {
              authController.logout();
              Get.back();
            },
            child: AppText("Logout".tr, color: Colors.red),
          ),
        ],
      );
    },
  );
}
