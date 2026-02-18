import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/auth/views/widgets/sign_in_with_others.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_text_field.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_button.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_divider.dart';
import 'package:real_estate_app/features/auth/controllers/validator/auth_validators.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set status bar to light content (white icons/text)
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
                  SizedBox(height: Get.height * 0.1),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Sign In",
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),

                  // Email/Phone Field
                  AuthTextField(
                    label: "Email/Phone",
                    hintText: "Enter Email / Phone Number",
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidators.validateEmailOrPhone,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Password Field
                  AuthTextField(
                    label: "Password",
                    hintText: "Enter Password",
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.handleSignIn(),
                    validator: AuthValidators.validatePassword,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgotPassword);
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: AppText(
                            "Forgot Password?",
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Sign In Button
                  AuthButton(
                    text: "Sign In",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.handleSignIn();
                      }
                    },
                    isLoading: controller.isLoading,
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Divider
                  const AuthDivider(),

                  SizedBox(height: Get.height * 0.02),

                  SignInWithOthers(),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Don't have an account? ",
                        color: AppColors.white,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.register);
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: AppText(
                            "Sign Up",
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
