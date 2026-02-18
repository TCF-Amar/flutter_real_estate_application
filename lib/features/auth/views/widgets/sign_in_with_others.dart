import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';

class SignInWithOthers extends StatelessWidget {
  final bool? isLoading;
  const SignInWithOthers({super.key, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          backgroundColor: AppColors.white,
          textColor: AppColors.textPrimary,
          icon: SvgPicture.asset(Assets.icons.google),
          text: "Continue with Google",
          onPressed: () {},
          isLoading: isLoading ?? false,
        ),
        SizedBox(height: Get.height * 0.02),
        AppButton(
          backgroundColor: AppColors.white,
          textColor: AppColors.textPrimary,
          icon: SvgPicture.asset(Assets.icons.apple),
          text: "Continue with Apple",
          onPressed: () {},
          isLoading: isLoading ?? false,
        ),
        SizedBox(height: Get.height * 0.02),
      ],
    );
  }
}
