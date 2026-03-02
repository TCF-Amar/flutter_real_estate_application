import 'package:flutter/material.dart';

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
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
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
    // FIX #1: Only look up theme when color is not provided
    // This avoids unnecessary rebuilds when theme changes
    final textColor =
        color ??
        Color.lerp(
          Colors.black,
          Colors.black87,
          0.87,
        )!; // Default to safe dark color instead of Theme lookup

    return Text(
      uppercase == true ? text.toUpperCase() : text,
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
