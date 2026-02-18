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
                textColor ?? AppColors.white ?? Colors.white,
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
      ),
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );

    return button;
  }
}
