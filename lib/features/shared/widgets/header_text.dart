import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const HeaderText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.black.withValues(alpha: 0.70),
    );
  }
}
