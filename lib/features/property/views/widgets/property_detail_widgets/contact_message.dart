import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ContactMessage extends StatelessWidget {
  const ContactMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 25, left: 16, right: 16),
      height: 300,
      width: .infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: AppImage(
                      path: controller.currentUser?.data.profile.profileImage,
                      radius: BorderRadius.circular(50),
                      errorIcon: Icons.person,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      AppText(
                        controller.currentUser?.data.user.fullName ?? "",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        controller.currentUser?.data.user.email ?? "",
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
