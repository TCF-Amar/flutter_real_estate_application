import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<ProfileController>();
    return Scaffold(
      appBar: DefaultAppBar(title: "Change Password"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  AppTextFormField(
                    hintText: "Current Password",
                    labelText: "Current Password",

                    // borderSideType: BorderSideType.,
                    borderColor: AppColors.grey.withValues(alpha: 0.5),
                    onChanged: (value) {
                      controller.currentPassword.value = value;
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter current password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  AppTextFormField(
                    hintText: "New Password",
                    labelText: "New Password",
                    // borderSideType: BorderSideType.bottom,
                    borderColor: AppColors.grey.withValues(alpha: 0.5),
                    onChanged: (value) {
                      controller.newPassword.value = value;
                    },
                    hintColor: AppColors.grey.withValues(alpha: 0.5),
                    isPassword: true,
                    // prefixIcon: AppSvg(path: Assets.icons.person),
                    iconSize: 8,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter new password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  AppTextFormField(
                    hintText: "Confirm New Password",
                    labelText: "Confirm New Password",

                    // borderSideType: BorderSideType.bottom,
                    // borderColor: AppColors.grey.withValues(alpha: 0.5),
                    onChanged: (value) {
                      controller.confirmPassword.value = value;
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter confirm new password";
                      }
                      if (v != controller.newPassword.value) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  // Spacer(),
                  SizedBox(height: 20),
                  Obx(
                    () => AppButton(
                      text: "Update",
                      isLoading: controller.passChanging.value,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.changePassword();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
