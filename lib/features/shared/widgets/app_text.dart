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
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      uppercase == true ? text.toUpperCase() : text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
      ),
    );
  }
}
