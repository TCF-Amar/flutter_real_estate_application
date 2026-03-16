import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;

  // typography
  final double fontSize;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final double? height;

  // colors & style
  final Color? color;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final bool? uppercase;
  // behavior
  final int? maxLines;
  final TextOverflow overflow;
  final bool? shadow;
  final Color? shadowColor;

  const AppText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.color = AppColors.textPrimary,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.uppercase,
    this.shadow,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Color.lerp(Colors.black, Colors.black87, 0.87)!;

    return Text(
      (uppercase == true ? text.toUpperCase() : text).tr,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
        // FIX #2: Pre-build shadows list to avoid recreation
        shadows: shadow == true
            ? [
                Shadow(
                  color: shadowColor ?? Colors.black,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
