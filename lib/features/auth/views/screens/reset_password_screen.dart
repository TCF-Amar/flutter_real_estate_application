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

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Reset password with new password
      Get.snackbar(
        'Success',
        'Password reset successfully',
        backgroundColor: AppColors.success.withValues(alpha: 0.8),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      // Navigate back to login
      Get.offAllNamed(AppRoutes.login);
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
                      "Reset Password",
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
                      "Create a strong password for your account.",
                      fontSize: 14,
                      color: AppColors.white?.withValues(alpha: 0.7),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // New Password Field
                  AuthTextField(
                    label: "New Password",
                    hintText: "Enter new password",
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validateStrongPassword,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Confirm Password Field
                  AuthTextField(
                    label: "Confirm Password",
                    hintText: "Enter Confirm password",
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        AuthValidators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                    onFieldSubmitted: (_) => _handleResetPassword(),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Reset Password Button
                  AuthButton(
                    text: "Reset Password",
                    onPressed: _handleResetPassword,
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
