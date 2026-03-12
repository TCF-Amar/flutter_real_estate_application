import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';

enum BorderSideType { all, bottom, top, left, right }

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  final bool obscureText;
  final bool isPassword;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;

  final bool enabled;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final bool border;

  final BorderRadius? borderRadius;
  final BorderSideType borderSideType;
  // final bool borderTop;
  // final bool borderBottom;
  // final bool borderLeft;
  // final bool borderRight;

  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;

  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  final EdgeInsetsGeometry? contentPadding;

  final String? prefixText;
  final double? fontSize;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.border = true,
    this.borderRadius,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.contentPadding,
    this.prefixText,
    this.borderSideType = BorderSideType.all,
    this.fontSize,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  void togglePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  InputBorder _buildInputBorder(Color color, {double width = 1.0}) {
    if (!widget.border) {
      return InputBorder.none;
    }

    // Only apply border radius if the specified side type is "all".
    // For specific sides (top, bottom, left, right), we use no border radius.
    final radius = (widget.borderSideType == BorderSideType.all)
        ? (widget.borderRadius ?? BorderRadius.circular(8))
        : BorderRadius.zero;

    switch (widget.borderSideType) {
      case BorderSideType.bottom:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
          borderRadius: radius,
        );
      case BorderSideType.top:
      case BorderSideType.left:
      case BorderSideType.right:
      case BorderSideType.all:
        return OutlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
          borderRadius: radius,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? AppColors.grey;
    final focusedColor = widget.focusedBorderColor ?? AppColors.primary;
    final errorColor = widget.errorBorderColor ?? AppColors.error;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscure : widget.obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      style: (widget.textColor != null || widget.fontSize != null)
          ? TextStyle(color: widget.textColor, fontSize: widget.fontSize ?? 16)
          : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixText: widget.prefixText,

        hintStyle: TextStyle(
          color: widget.hintColor ?? Colors.grey,
          fontSize: widget.fontSize ?? 16,
        ),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _buildInputBorder(borderColor),
        enabledBorder: _buildInputBorder(borderColor),
        focusedBorder: _buildInputBorder(focusedColor),
        errorBorder: _buildInputBorder(errorColor),
        focusedErrorBorder: _buildInputBorder(errorColor),
        disabledBorder: _buildInputBorder(borderColor.withValues(alpha: 0.5)),

        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(child: widget.prefixIcon),
                ),
              )
            : null,

        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),

        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: togglePassword,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppSvg(
                    path: obscure ? Assets.icons.eyeOff : Assets.icons.eyeOn,
                    color:
                        widget.iconColor ?? Theme.of(context).iconTheme.color,
                  ),
                ),
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: widget.fillColor ?? Colors.grey.withValues(alpha: 0.08),
      ),
    );
  }
}
