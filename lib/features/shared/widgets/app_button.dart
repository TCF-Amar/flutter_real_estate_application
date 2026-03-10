import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  final double? width;
  final bool fullWidth;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;

  final double? fontSize;
  final FontWeight? fontWeight;

  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  final Widget? icon;

  final bool showShadow;

  final bool isBorder;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.fullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.showShadow = true,
    this.isBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? AppColors.primary;
    final Color txtColor = textColor ?? AppColors.white;

    Widget child;

    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(txtColor),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 10),
          AppText(
            text,
            color: txtColor,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ],
      );
    } else {
      child = AppText(
        text,
        color: txtColor,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w600,
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: (isLoading || !isEnabled) ? null : onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            padding ?? const EdgeInsets.symmetric(vertical: 16),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledBackgroundColor ?? Colors.grey.shade400;
            }
            return bgColor;
          }),
          elevation: WidgetStateProperty.all(showShadow ? 4 : 0),
          shadowColor: WidgetStateProperty.all(
            showShadow
                ? Colors.black.withValues(alpha: .3)
                : Colors.transparent,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: isBorder
                  ? BorderSide(color: borderColor ?? bgColor)
                  : BorderSide.none,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
