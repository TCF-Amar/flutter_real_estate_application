import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/controllers/validator/auth_validators.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_divider.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_text_field.dart';
import 'package:real_estate_app/features/auth/views/widgets/sign_in_with_others.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

// ignore: must_be_immutable
class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  SizedBox(height: Get.height * 0.05),

                  // Header with Back Button
                  Row(
                    children: [
                      Container(
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
                      const Spacer(),
                      AppText(
                        "Sign Up",
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Full Name Field
                  AuthTextField(
                    label: "Full Name",
                    hintText: "Enter your full name",
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validateName,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Email Field
                  AuthTextField(
                    label: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validateEmail,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Phone Field
                  AuthTextField(
                    label: "Phone Number",
                    hintText: "Enter your phone number",
                    prefixIcon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validatePhone,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Password Field
                  AuthTextField(
                    label: "Password",
                    hintText: "Create a password",
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validatePassword,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Confirm Password Field
                  AuthTextField(
                    label: "Confirm Password",
                    hintText: "Re-enter your password",
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        AuthValidators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                  ),

                  SizedBox(height: Get.height * 0.04),

                  // Sign Up Button
                  AuthButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.toNamed(
                          AppRoutes.verifyCode,
                          arguments: {'source': 'signup'},
                        );
                      }
                    },
                    isLoading: controller.isLoading,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Divider
                  const AuthDivider(),

                  SizedBox(height: Get.height * 0.02),

                  // Social Sign Up Options
                  const SignInWithOthers(),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Already have an account? ",
                        color: AppColors.white,
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: AppText(
                            "Sign In",
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Get.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
