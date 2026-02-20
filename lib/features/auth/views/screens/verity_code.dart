import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/verify_code_widgets.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class VerifyCodeScreen extends GetView<AuthController> {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read source from route arguments and init controller state
    final args = Get.arguments as Map<String, dynamic>?;
    controller.initVerifyCode(args?['source'] as String?);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.getStart2),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.9),
                  AppColors.background.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          // Content
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(height: Get.height * 0.05),

                // Header
                const VerifyCodeHeader(),

                SizedBox(height: Get.height * 0.08),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText(
                    "We've sent a 6-digit code to your email — enter it below to verify your account.",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withValues(alpha: 0.9),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                // OTP Input Fields
                VerifyCodeOtpRow(
                  controllers: controller.codeControllers,
                  focusNodes: controller.codeFocusNodes,
                  onChanged: controller.onCodeChanged,
                ),

                SizedBox(height: Get.height * 0.03),

                // Paste Button
                VerifyCodePasteButton(onTap: controller.handlePaste),

                SizedBox(height: Get.height * 0.04),

                // Resend Row — reactive with Obx
                Obx(
                  () => VerifyCodeResendRow(
                    canResend: controller.canResend.value,
                    countdown: controller.resendCountdown.value,
                    onResend: controller.handleResendCode,
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                // Verify Button
                Obx(
                  () => AuthButton(
                    text: "Verify",
                    onPressed: controller.handleVerify,
                    isLoading: controller.isLoading,
                  ),
                ),

                SizedBox(height: Get.height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
