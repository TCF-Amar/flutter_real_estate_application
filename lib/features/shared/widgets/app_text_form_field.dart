import 'package:flutter/material.dart';
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

  Border _buildBorder(Color color) {
    switch (widget.borderSideType) {
      case BorderSideType.bottom:
        return Border(bottom: BorderSide(color: color));

      case BorderSideType.top:
        return Border(top: BorderSide(color: color));

      case BorderSideType.left:
        return Border(left: BorderSide(color: color));

      case BorderSideType.right:
        return Border(right: BorderSide(color: color));

      case BorderSideType.all:
        return Border.all(color: color);
    }
  }

  BorderRadius? _getBorderRadius() {
    if (widget.borderRadius != null) {
      return widget.borderRadius;
    }

    if (widget.borderSideType == BorderSideType.all || widget.border) {
      return BorderRadius.circular(8);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? Theme.of(context).dividerColor;

    return Container(
      decoration: widget.border
          ? BoxDecoration(
              border: _buildBorder(borderColor),
              borderRadius: _getBorderRadius(),
            )
          : null,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? obscure : widget.obscureText,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        enabled: widget.enabled,
        style: (widget.textColor != null || widget.fontSize != null)
            ? TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize ?? 16,
              )
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
          border: InputBorder.none,

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
      ),
    );
  }
}
