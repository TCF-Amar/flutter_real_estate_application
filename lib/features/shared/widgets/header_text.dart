import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.black.withValues(alpha: 0.70),
    );
  }
}