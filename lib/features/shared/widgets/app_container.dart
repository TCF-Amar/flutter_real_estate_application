import 'package:flutter/material.dart';
import 'dart:ui' show BorderStyle;

import 'package:real_estate_app/features/shared/widgets/app_text_form_field.dart';

// enum BorderSideType { all, bottom, top, left, right }

class AppContainer extends StatelessWidget {
  // ----- Core content -----
  final Widget? child;

  // ----- Layout -----
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  // ----- Decoration (base) -----
  final Decoration? decoration; // full override
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? image;
  final BoxBorder? border; // custom border (overrides simplified border)
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow; // full custom shadows
  final BlendMode? backgroundBlendMode;
  final BoxShape? shape;

  // ----- Simplified border controls (used only if border == null) -----
  final bool showBorder;
  final BorderSideType borderSideType;
  final Color borderColor;
  final double borderWidth;
  final BorderStyle borderStyle;

  // ----- Simplified shadow controls (used only if boxShadow == null) -----
  final bool showShadow; // master switch
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final double? shadowSpreadRadius;

  // ----- Legacy elevation (used only if no boxShadow and no simple shadow params) -----
  final double? elevation;

  // ----- Foreground decoration -----
  final Decoration? foregroundDecoration;

  // ----- Interaction -----
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool enableRipple;
  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;

  // ----- Clipping -----
  final Clip clipBehavior;
  final bool clipContent; // convenience: forces clipBehavior = Clip.antiAlias

  // ----- Expand / sizing helpers -----
  final bool expand; // makes width infinite

  const AppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
    this.decoration,
    this.color,
    this.gradient,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.backgroundBlendMode,
    this.shape,
    // Simplified border
    this.showBorder = false,
    this.borderSideType = BorderSideType.all,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderStyle = BorderStyle.solid,
    // Simplified shadow
    this.showShadow = true,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.shadowSpreadRadius,
    // Legacy elevation
    this.elevation,
    this.foregroundDecoration,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.enableRipple = true,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.clipBehavior = Clip.none,
    this.clipContent = false,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    // --- Determine effective border ---
    final BoxBorder? effectiveBorder =
        border ?? (showBorder ? _buildBorderFromSideType() : null);

    // --- Determine effective shadows ---
    final List<BoxShadow>? effectiveBoxShadow = _buildShadows();

    // --- Effective decoration (if not overridden) ---
    final effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: color,
          gradient: gradient,
          image: image,
          border: effectiveBorder,
          borderRadius: shape == BoxShape.circle
              ? BorderRadius.circular(12)
              : borderRadius ?? BorderRadius.circular(12),
          boxShadow: effectiveBoxShadow,
          shape: shape ?? BoxShape.rectangle,
        );

    // --- Determine final border radius (for InkWell & clipping) ---
    BorderRadiusGeometry? effectiveBorderRadius;
    if (effectiveDecoration is BoxDecoration) {
      effectiveBorderRadius = effectiveDecoration.borderRadius;
    } else {
      effectiveBorderRadius = borderRadius;
    }

    // --- Effective clip behavior ---
    final effectiveClip = clipContent ? Clip.antiAlias : clipBehavior;

    // --- Build inner content (padding, alignment, constraints, optional child clipping) ---
    Widget innerContent = Container(
      width: expand ? double.infinity : width,
      height: height,
      constraints: constraints,
      padding: padding,
      alignment: alignment,
      child: effectiveClip != Clip.none && effectiveBorderRadius != null
          ? ClipRRect(borderRadius: effectiveBorderRadius, child: child)
          : child,
    );

    // --- Apply foreground decoration if provided ---
    if (foregroundDecoration != null) {
      innerContent = DecoratedBox(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        child: innerContent,
      );
    }

    // --- No interaction ---
    if (onTap == null && onLongPress == null && onDoubleTap == null) {
      return Container(
        width: expand ? double.infinity : width,
        height: height,
        constraints: constraints,
        margin: margin,
        padding: padding,
        alignment: alignment,
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: effectiveClip,
        child: child,
      );
    }

    // --- Interactive with ripple ---
    if (enableRipple) {
      Widget materialChild = Ink(
        decoration: effectiveDecoration,
        child: InkWell(
          borderRadius: effectiveBorderRadius is BorderRadius
              ? effectiveBorderRadius as BorderRadius
              : null,
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          splashColor: splashColor,
          highlightColor: highlightColor,
          splashFactory: splashFactory,
          child: innerContent,
        ),
      );

      if (foregroundDecoration != null) {
        materialChild = DecoratedBox(
          decoration: foregroundDecoration!,
          position: DecorationPosition.foreground,
          child: materialChild,
        );
      }

      return _wrapWithMargin(
        margin,
        Material(
          color: Colors.transparent,
          clipBehavior: effectiveClip,
          type: MaterialType.transparency,
          child: materialChild,
        ),
      );
    }

    // --- Interactive without ripple (GestureDetector) ---
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: Container(
        width: expand ? double.infinity : width,
        height: height,
        constraints: constraints,
        margin: margin,
        padding: padding,
        alignment: alignment,
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: effectiveClip,
        child: child,
      ),
    );
  }

  // Helper to apply margin
  Widget _wrapWithMargin(EdgeInsetsGeometry? margin, Widget child) {
    return margin != null ? Padding(padding: margin, child: child) : child;
  }

  // Build shadows based on simplified parameters, boxShadow, or elevation
  List<BoxShadow>? _buildShadows() {
    if (!showShadow) return null;

    // 1. If boxShadow is explicitly provided, use it
    if (boxShadow != null) return boxShadow;

    // 2. If any simple shadow param is provided, create a single BoxShadow
    final hasSimpleShadow =
        shadowColor != null ||
        shadowBlurRadius != null ||
        shadowOffset != null ||
        shadowSpreadRadius != null;
    if (hasSimpleShadow) {
      return [
        BoxShadow(
          color: shadowColor ?? Colors.black.withValues(alpha: 0.15),
          blurRadius: shadowBlurRadius ?? 4.0,
          offset: shadowOffset ?? const Offset(0, 2),
          spreadRadius: shadowSpreadRadius ?? 0,
        ),
      ];
    }

    // 3. Fall back to elevation-based shadow (if elevation > 0)
    if (elevation != null && elevation! > 0) {
      return [
        BoxShadow(
          blurRadius: elevation! * 2,
          offset: Offset(0, elevation!),
          color: Colors.black.withOpacity(0.15),
        ),
      ];
    }

    // 4. No shadow
    return null;
  }

  BoxBorder _buildBorderFromSideType() {
    final side = BorderSide(
      color: borderColor,
      width: borderWidth,
      style: borderStyle,
    );

    switch (borderSideType) {
      case BorderSideType.all:
        return Border.all(
          color: borderColor,
          width: borderWidth,
          style: borderStyle,
        );
      case BorderSideType.bottom:
        return Border(bottom: side);
      case BorderSideType.top:
        return Border(top: side);
      case BorderSideType.left:
        return Border(left: side);
      case BorderSideType.right:
        return Border(right: side);
    }
  }
}
