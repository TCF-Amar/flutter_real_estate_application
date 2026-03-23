import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class EmailField extends StatelessWidget {
  final ProfileController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Email'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(
                () => AppTextFormField(
                  hintText: 'Enter email',
                  fontSize: 14,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  borderRadius: BorderRadius.zero,
                  showBorder: true,
                  borderWidth: 2,
                  borderSideType: BorderSideType.bottom,
                  prefixIcon: AppSvg(
                    path: Assets.icons.mail,
                    // width: 12,
                    // height: 12,
                  ),
                  suffixIcon: controller.isEmailVerified
                      ? const Icon(Icons.verified, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => AppButton(
                  text: controller.isEmailVerified ? 'Verified' : 'Verify',
                  onPressed: controller.isEmailVerified
                      ? () {}
                      : () => controller.verifyField('email'),
                  fontSize: 14,
                  backgroundColor: controller.isEmailVerified
                      ? AppColors.primary
                      : Colors.transparent,
                  showShadow: controller.isEmailVerified,
                  isLoading: controller.isVerifyingEmail,
                  isBorder: !controller.isEmailVerified,
                  borderColor: AppColors.primary,
                  textColor: controller.isEmailVerified
                      ? null
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
