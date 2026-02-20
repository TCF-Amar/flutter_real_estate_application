import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/controllers/validator/auth_validators.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_text_field.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _handleSendCode() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Code Sent',
        'Verification code sent to ${_emailController.text}',
        backgroundColor: AppColors.success.withValues(alpha: 0.8),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      // Navigate to verify code screen with forgot-password source
      Get.toNamed(
        AppRoutes.verifyCode,
        arguments: {'source': 'forgot-password'},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    // Set status bar to light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

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
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  SizedBox(height: Get.height * 0.02),

                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Title
                  Center(
                    child: AppText(
                      "Forget Password",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: Get.height * 0.03),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AppText(
                      "Enter your registered email address or phone number, and we'll send you a code to reset your password.",
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.7),
                      textAlign: TextAlign.center,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Email/Phone Field
                  AuthTextField(
                    label: "Email / Phone",
                    hintText: "Enter Email / phone number",
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: AuthValidators.validateEmailOrPhone,
                    onFieldSubmitted: (_) => _handleSendCode(),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Send Button
                  AuthButton(
                    text: "Send",
                    onPressed: _handleSendCode,
                    isLoading: controller.isLoading,
                  ),

                  SizedBox(height: Get.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
