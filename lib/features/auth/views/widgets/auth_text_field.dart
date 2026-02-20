import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/app_text_form_field.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 16, color: AppColors.white),
        const SizedBox(height: 8),
        AppTextFormField(
          controller: controller,
          hintText: hintText,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          
          
          isPassword: isPassword,
          prefixIcon: Icon(prefixIcon, size: 20),
          textColor: AppColors.white,
          hintColor: AppColors.white.withValues(alpha: 0.6),
          iconColor: AppColors.white,
          customFillColor: Colors.transparent,
          borderColor: AppColors.white.withValues(alpha: 0.3),
          focusedBorderColor: AppColors.primary,
          border: false,
        ),
      ],
    );
  }
}
