import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PhoneField extends StatelessWidget {
  final ProfileController controller;
  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Phone Number'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(
                () => AppTextFormField(
                  hintText: 'Enter phone number',
                  fontSize: 14,
                  controller: controller.phoneController,
                  showBorder: true,
                  borderWidth: 2,
                  borderSideType: BorderSideType.bottom,
                  keyboardType: TextInputType.phone,
                  borderRadius: BorderRadius.zero,
                  prefixIcon: AppSvg(
                    path: Assets.icons.phone,
                  ),
                  suffixIcon: controller.isPhoneVerified
                      ? const Icon(Icons.verified, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => AppButton(
                  text: controller.isPhoneVerified ? 'Verified' : 'Verify',
                  fontSize: 14,
                  backgroundColor: controller.isPhoneVerified
                      ? AppColors.primary
                      : Colors.transparent,
                  onPressed: controller.isPhoneVerified
                      ? () {}
                      : () {
                          controller.verifyField('phone');
                        },
                  showShadow: controller.isPhoneVerified,
                  isLoading: controller.isVerifyingPhone,
                  isBorder: !controller.isPhoneVerified,
                  borderColor: AppColors.primary,
                  textColor: controller.isPhoneVerified
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
