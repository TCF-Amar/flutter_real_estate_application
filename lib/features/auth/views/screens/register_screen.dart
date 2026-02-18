import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_divider.dart';
import 'package:real_estate_app/features/auth/views/widgets/register_widgets.dart';
import 'package:real_estate_app/features/auth/views/widgets/sign_in_with_others.dart';

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
                  const RegisterHeader(),

                  SizedBox(height: Get.height * 0.05),

                  // Form Fields
                  RegisterFormFields(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
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
                  const RegisterSignInLink(),

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
