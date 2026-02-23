import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? icon;
  final bool fullWidth;
  final bool showShadow;
  final bool isBorder;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    this.icon,
    this.fullWidth = true,
    this.showShadow = true,
    this.isBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? AppColors.white,
              ),
            ),
          )
        : icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20, width: 20, child: icon!),
              const SizedBox(width: 12),
              AppText(
                text,
                color: textColor ?? AppColors.white,
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ],
          )
        : AppText(
            text,
            color: textColor ?? AppColors.white,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w600,
          );

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: backgroundColor ?? AppColors.primary,
        disabledBackgroundColor:
            disabledBackgroundColor ??
            (backgroundColor ?? AppColors.primary).withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
        shadowColor: showShadow
            ? AppColors.black.withValues(alpha: 0.5)
            : Colors.transparent,
        elevation: showShadow ? 4 : 0,
        side: isBorder
            ? BorderSide(color: borderColor ?? AppColors.primary, width: 1)
            : BorderSide.none,
      ),
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );

    return button;
  }
}
