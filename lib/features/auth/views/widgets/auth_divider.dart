import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, this.text = "Or"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.white.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppText(
            text,
            color: AppColors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.white.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
