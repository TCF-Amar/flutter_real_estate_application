import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text("Logout"),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout from your account?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          AppButton(
            text: "Logout",
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      );
    },
  );
}
