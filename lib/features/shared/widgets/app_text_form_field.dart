import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/app_svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'app_container.dart';

enum BorderSideType { all, bottom, top, left, right }

class AppTextFormField extends StatefulWidget {
  // ---------- TextFormField specific properties ----------
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
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? prefixText;
  final double? fontSize;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  // ---------- Outer container properties (mirror AppContainer) ----------
  final EdgeInsetsGeometry? containerMargin;
  final EdgeInsetsGeometry? containerPadding;
  final double? containerWidth;
  final double? containerHeight;
  final AlignmentGeometry? containerAlignment;
  final BoxConstraints? containerConstraints;
  final Decoration? containerDecoration; // full override
  final Color? containerColor; // background color of container
  final Gradient? containerGradient;
  final DecorationImage? containerImage;
  final BoxBorder? containerBorder; // overrides simplified border
  final List<BoxShadow>? containerBoxShadow;
  final BlendMode? containerBackgroundBlendMode;
  final BoxShape? containerShape;

  // Simplified border (used if containerBorder == null)
  final bool showContainerBorder;
  final BorderSideType containerBorderSideType;
  final Color containerBorderColor;
  final double containerBorderWidth;
  final BorderStyle containerBorderStyle;

  // Simplified shadow (used if containerBoxShadow == null)
  final bool showContainerShadow;
  final Color? containerShadowColor;
  final double? containerShadowBlurRadius;
  final Offset? containerShadowOffset;
  final double? containerShadowSpreadRadius;

  // Elevation fallback
  final double? containerElevation;

  // Foreground decoration
  final Decoration? containerForegroundDecoration;

  // Clipping
  final Clip containerClipBehavior;

  // Expand helper
  final bool containerExpand;

  // ---------- Border radius for the container ----------
  final BorderRadiusGeometry? containerBorderRadius;

  const AppTextFormField({
    super.key,
    // TextFormField params
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
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixText,
    this.fontSize,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.fillColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    // Container params with improved defaults
    this.containerMargin,
    this.containerPadding,
    this.containerWidth,
    this.containerHeight,
    this.containerAlignment,
    this.containerConstraints,
    this.containerDecoration,
    this.containerColor, // will default to white in build
    this.containerGradient,
    this.containerImage,
    this.containerBorder,
    this.containerBorderRadius, // user explicit override
    this.containerBoxShadow,
    this.containerBackgroundBlendMode,
    this.containerShape,
    this.showContainerBorder = true, // default to true
    this.containerBorderSideType = BorderSideType.all,
    this.containerBorderColor = Colors.grey, // you can change to a softer grey
    this.containerBorderWidth = 1.0,
    this.containerBorderStyle = BorderStyle.solid,
    this.showContainerShadow = true,
    this.containerShadowColor,
    this.containerShadowBlurRadius,
    this.containerShadowOffset,
    this.containerShadowSpreadRadius,
    this.containerElevation,
    this.containerForegroundDecoration,
    this.containerClipBehavior = Clip.none,
    this.containerExpand = false,
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

  @override
  Widget build(BuildContext context) {
    // ----- Determine effective borderRadius -----
    // If user explicitly provided borderRadius, use it
    // Otherwise, apply a default radius ONLY if border is on all sides
    final effectiveBorderRadius =
        widget.containerBorderRadius ??
        (widget.showContainerBorder &&
                widget.containerBorderSideType == BorderSideType.all
            ? BorderRadius.circular(8) // default radius
            : null);

    // ----- Default container color (if not set) -----
    // Use white, but you could also use Theme.of(context).cardColor
    final effectiveContainerColor = widget.containerColor ?? Colors.white;

    // Build the inner TextFormField with NO border (container handles it)
    final textField = TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscure : widget.obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
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
        // No border – the container provides it
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

        contentPadding: widget.contentPadding,

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

    // Wrap with AppContainer
    return AppContainer(
      // Layout
      margin: widget.containerMargin,
      padding: widget.containerPadding,
      width: widget.containerWidth,
      height: widget.containerHeight,
      alignment: widget.containerAlignment,
      constraints: widget.containerConstraints,
      // Decoration
      decoration: widget.containerDecoration,
      color: effectiveContainerColor,
      gradient: widget.containerGradient,
      image: widget.containerImage,
      border: widget.containerBorder,
      borderRadius: effectiveBorderRadius, // use our computed value
      boxShadow: widget.containerBoxShadow,
      backgroundBlendMode: widget.containerBackgroundBlendMode,
      shape: widget.containerShape,
      // Simplified border
      showBorder: widget.showContainerBorder,
      borderSideType: widget.containerBorderSideType,
      borderColor: widget.containerBorderColor,
      borderWidth: widget.containerBorderWidth,
      borderStyle: widget.containerBorderStyle,
      // Simplified shadow
      showShadow: widget.showContainerShadow,
      shadowColor: widget.containerShadowColor,
      shadowBlurRadius: widget.containerShadowBlurRadius,
      shadowOffset: widget.containerShadowOffset,
      shadowSpreadRadius: widget.containerShadowSpreadRadius,
      // Elevation
      elevation: widget.containerElevation,
      // Foreground decoration
      foregroundDecoration: widget.containerForegroundDecoration,
      // Clipping
      clipBehavior: widget.containerClipBehavior,
      // Expand
      expand: widget.containerExpand,
      // Child
      child: textField,
    );
  }
}
