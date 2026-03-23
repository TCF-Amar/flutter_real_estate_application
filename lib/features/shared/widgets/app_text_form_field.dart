import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/app_svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';

enum BorderSideType { all, bottom, top, left, right }

class AppTextFormField extends StatefulWidget {
  // TextFormField properties
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
  final Color? labelColor;
  final Color? iconColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool autoValidateMode;
  final FocusNode? focusNode;
  final double iconSize;

  // Border properties
  final bool showBorder;
  final BorderSideType borderSideType;
  final Color borderColor;
  final double borderWidth;
  final BorderStyle borderStyle;

  /// Extra width added to [borderWidth] when the field is focused.
  final double focusedBorderWidthDelta;

  // Container properties
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;

  /// Material elevation applied via a [Material] wrapper when > 0.
  final double? elevation;
  final Clip clipBehavior;
  final String? labelTop;

  /// Vertical gap between [labelTop] and the field.
  final double labelTopSpacing;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? labelTopTextColor;

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
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixText,
    this.fontSize,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.iconColor,
    this.fillColor,
    this.contentPadding,
    this.autoValidateMode = false,
    this.focusNode,
    this.iconSize = 20.0,
    // Border props
    this.showBorder = true,
    this.borderSideType = BorderSideType.all,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderStyle = BorderStyle.solid,
    this.focusedBorderWidthDelta = 0.5,
    // Container props
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.constraints,
    this.backgroundColor,
    this.gradient,
    this.boxShadow,
    this.borderRadius,
    this.elevation,
    this.clipBehavior = Clip.none,
    this.labelTop,
    this.labelTopSpacing = 6.0,
    this.crossAxisAlignment,
    this.labelTopTextColor,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword || widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  BorderRadius get _effectiveBorderRadius =>
      widget.borderRadius ??
      (widget.borderSideType == BorderSideType.all
          ? BorderRadius.circular(12)
          : BorderRadius.zero);

  InputBorder _buildBorder({Color? color, double? width}) {
    if (!widget.showBorder) return InputBorder.none;

    final side = BorderSide(
      color: color ?? widget.borderColor,
      width: width ?? widget.borderWidth,
      style: widget.borderStyle,
    );

    switch (widget.borderSideType) {
      case BorderSideType.all:
        return OutlineInputBorder(
          borderSide: side,
          borderRadius: _effectiveBorderRadius,
        );
      case BorderSideType.bottom:
        return UnderlineInputBorder(
          borderSide: side,
          borderRadius: _effectiveBorderRadius,
        );
      // Flutter's built-in InputBorder doesn't support top / left / right,
      // so we use a lightweight custom painter for those cases.
      case BorderSideType.top:
        return _SidedBorder(side: side, sides: _VisibleSides.top);
      case BorderSideType.left:
        return _SidedBorder(side: side, sides: _VisibleSides.left);
      case BorderSideType.right:
        return _SidedBorder(side: side, sides: _VisibleSides.right);
    }
  }

  Widget _buildPrefixIcon(Color iconColor) {
    // Size the wrapper dynamically from iconSize + padding so it never clips.
    return Container(
      padding: EdgeInsets.all(8),
      width: widget.iconSize + 12,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: IconTheme(
          data: IconThemeData(size: widget.iconSize, color: iconColor),
          child: SizedBox.square(
            dimension: widget.iconSize,
            child: widget.prefixIcon,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordToggle(Color iconColor) {
    return InkWell(
      onTap: _togglePasswordVisibility,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IconTheme(
          data: IconThemeData(size: widget.iconSize, color: iconColor),
          child: AppSvg(
            path: _obscureText ? Assets.icons.eyeOff : Assets.icons.eyeOn,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: widget.fontSize ?? 16,
      color: widget.textColor,
    );

    final effectiveHintColor =
        widget.hintColor ?? Colors.grey.withValues(alpha: 0.7);
    final effectiveLabelColor = widget.labelColor ?? effectiveHintColor;
    final effectiveIconColor = widget.iconColor ?? Colors.grey;
    final effectiveFillColor = widget.fillColor ?? Colors.transparent;
    final effectiveBgColor = widget.backgroundColor ?? Colors.transparent;

    final prefixIconWidget = widget.prefixIcon != null
        ? _buildPrefixIcon(effectiveIconColor)
        : null;

    final suffixIconWidget = widget.isPassword
        ? _buildPasswordToggle(effectiveIconColor)
        : widget.suffixIcon;

    Widget field = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      style: textStyle,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixText: widget.prefixText,
        prefixIcon: prefixIconWidget,
        suffixIcon: suffixIconWidget,
        labelStyle: textStyle.copyWith(color: effectiveLabelColor),
        hintStyle: textStyle.copyWith(color: effectiveHintColor),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(
          width: widget.borderWidth + widget.focusedBorderWidthDelta,
        ),
        errorBorder: _buildBorder(color: Colors.red),
        focusedErrorBorder: _buildBorder(color: Colors.red, width: 2),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: effectiveFillColor,
        isDense: true,
        alignLabelWithHint: true,
      ),
    );

    // Apply Material elevation when requested.
    if ((widget.elevation ?? 0) > 0) {
      field = Material(
        elevation: widget.elevation!,
        borderRadius: _effectiveBorderRadius,
        color: Colors.transparent,
        child: field,
      );
    }

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      constraints: widget.constraints,
      clipBehavior: widget.clipBehavior,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        gradient: widget.gradient,
        borderRadius: _effectiveBorderRadius,
        boxShadow: widget.boxShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ don't expand vertically
        crossAxisAlignment:
            widget.crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          if (widget.labelTop != null) ...[
            Text(
              widget.labelTop!,
              style: textStyle.copyWith(color: widget.labelTopTextColor),
            ),
            SizedBox(height: widget.labelTopSpacing), // ✅ configurable gap
          ],
          field,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom InputBorder — draws only one side (top / left / right).
// ---------------------------------------------------------------------------

enum _VisibleSides { top, left, right }

class _SidedBorder extends InputBorder {
  final _VisibleSides sides;

  const _SidedBorder({required BorderSide side, required this.sides})
    : super(borderSide: side);

  @override
  InputBorder copyWith({BorderSide? borderSide}) =>
      _SidedBorder(side: borderSide ?? this.borderSide, sides: sides);

  @override
  bool get isOutline => false;

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: borderSide.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final paint = borderSide.toPaint();
    switch (sides) {
      case _VisibleSides.top:
        canvas.drawLine(rect.topLeft, rect.topRight, paint);
      case _VisibleSides.left:
        canvas.drawLine(rect.topLeft, rect.bottomLeft, paint);
      case _VisibleSides.right:
        canvas.drawLine(rect.topRight, rect.bottomRight, paint);
    }
  }

  @override
  ShapeBorder scale(double t) =>
      _SidedBorder(side: borderSide.scale(t), sides: sides);
}
