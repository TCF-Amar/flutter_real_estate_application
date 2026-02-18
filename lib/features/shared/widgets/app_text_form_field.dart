import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool isPassword;
  final bool border;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? customFillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.isPassword = false,
    this.border = false,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.customFillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor =
        widget.borderColor ?? Theme.of(context).dividerColor;
    final defaultFocusedBorderColor =
        widget.focusedBorderColor ?? Theme.of(context).primaryColor;
    final defaultErrorBorderColor = widget.errorBorderColor ?? Colors.red;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : widget.obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      style: widget.textColor != null
          ? TextStyle(color: widget.textColor)
          : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintColor != null
            ? TextStyle(color: widget.hintColor)
            : null,
        prefixIcon: widget.prefixIcon != null
            ? Container(
                width: 48,
                alignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(color: widget.iconColor),
                  child: widget.prefixIcon!,
                ),
              )
            : null,
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: _togglePasswordVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    _obscureText ? Assets.icons.eyeOff : Assets.icons.eyeOn,
                    colorFilter: ColorFilter.mode(
                      widget.iconColor ?? Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            : widget.suffixIcon != null
            ? IconTheme(
                data: IconThemeData(color: widget.iconColor),
                child: widget.suffixIcon!,
              )
            : null,
        border: widget.border
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(12))
            : const UnderlineInputBorder(),
        enabledBorder: widget.border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: defaultBorderColor),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: defaultBorderColor),
              ),
        focusedBorder: widget.border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: defaultFocusedBorderColor,
                  width: 2,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: defaultFocusedBorderColor,
                  width: 2,
                ),
              ),
        errorBorder: widget.border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: defaultErrorBorderColor),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: defaultErrorBorderColor),
              ),
        focusedErrorBorder: widget.border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: defaultErrorBorderColor,
                  width: 2,
                ),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: defaultErrorBorderColor,
                  width: 2,
                ),
              ),
        filled: true,
        fillColor:
            widget.customFillColor ??
            Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }
}
