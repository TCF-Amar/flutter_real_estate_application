import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;

  final double? height;
  final double? width;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;
  final Color? borderColor;

  final double radius;
  final double borderWidth;

  final bool? showShadow;
  final List<BoxShadow>? boxShadow;

  final bool? showBorder;
  final Border? border;

  const AppContainer({
    super.key,
    this.child,
    this.height,
    this.width = double.infinity,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.radius = 12,
    this.borderWidth = 1,
    this.boxShadow,
    this.showShadow = false,
    this.showBorder = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder == true
            ? border ??
                  Border.all(
                    color: borderColor ?? AppColors.grey.withValues(alpha: 0.2),
                    width: borderWidth,
                  )
            : border,
        boxShadow: showShadow == true
            ? boxShadow ??
                  [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
            : boxShadow,
      ),
      child: child,
    );
  }
}
