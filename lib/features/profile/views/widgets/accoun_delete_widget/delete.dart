import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
// import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

void accountDeleteConfirmation(BuildContext context, Function onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.delete, color: AppColors.error, size: 18),
            const AppText(
              'Delete ',
              fontSize: 16,
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            const AppText(
              'Account?',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const AppText('Delete', color: Colors.red),
            onPressed: () {
              // Perform account deletion logic here
              Get.back();
              onDelete();
            },
          ),
        ],
      );
    },
  );
}
