import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/validator/auth_validators.dart';
import 'package:real_estate_app/features/auth/views/widgets/auth_text_field.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

/// Back button + centered "Sign Up" title row.
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: 48),
      ],
    );
  }
}

/// All 5 registration form fields: name, email, phone, password, confirm password.
class RegisterFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name
        AuthTextField(
          label: "Full Name",
          hintText: "Enter your full name",
          prefixIcon: Icons.person_outline,
          controller: nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: AuthValidators.validateName,
        ),

        SizedBox(height: Get.height * 0.02),

        // Email
        AuthTextField(
          label: "Email",
          hintText: "Enter your email",
          prefixIcon: Icons.email_outlined,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: AuthValidators.validateEmail,
        ),

        SizedBox(height: Get.height * 0.02),

        // Phone
        AuthTextField(
          label: "Phone Number",
          hintText: "Enter your phone number",
          prefixIcon: Icons.phone_outlined,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: AuthValidators.validatePhone,
        ),

        SizedBox(height: Get.height * 0.02),

        // Password
        AuthTextField(
          label: "Password",
          hintText: "Create a password",
          prefixIcon: Icons.lock_outline,
          controller: passwordController,
          isPassword: true,
          textInputAction: TextInputAction.next,
          validator: AuthValidators.validatePassword,
        ),

        SizedBox(height: Get.height * 0.02),

        // Confirm Password
        AuthTextField(
          label: "Confirm Password",
          hintText: "Re-enter your password",
          prefixIcon: Icons.lock_outline,
          controller: confirmPasswordController,
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (value) => AuthValidators.validateConfirmPassword(
            value,
            passwordController.text,
          ),
        ),
      ],
    );
  }
}

/// "Already have an account? Sign In" link row.
class RegisterSignInLink extends StatelessWidget {
  const RegisterSignInLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText("Already have an account? ", color: AppColors.white),
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: AppText(
              "Sign In",
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
