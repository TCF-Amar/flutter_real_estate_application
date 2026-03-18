import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:real_estate_app/features/shared/widgets/app_text_form_field.dart';

enum AppBorderStyle { solid, dashed, dotted }

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
  final List<BoxShadow>? boxShadow;
  final BlendMode? backgroundBlendMode;
  final BoxShape? shape;

  // ----- Simplified border controls (used only if border == null) -----
  final bool showBorder;
  final BorderSideType borderSideType;
  final Color borderColor;
  final double borderWidth;
  // borderStyle is deprecated – use appBorderStyle instead
  final BorderStyle
  borderStyle; // kept for compatibility, but will be overridden by appBorderStyle
  final AppBorderStyle appBorderStyle; // solid, dashed, dotted

  // ----- Simplified shadow controls -----
  final bool showShadow;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final double? shadowSpreadRadius;
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
  final bool clipContent;
  final bool expand;

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
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.boxShadow,
    this.backgroundBlendMode,
    this.shape,
    // Simplified border
    this.showBorder = false,
    this.borderSideType = BorderSideType.all,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderStyle = BorderStyle.solid, // kept for compatibility
    this.appBorderStyle = AppBorderStyle.solid,
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
    // --- Determine effective border (only for solid style) ---
    // If we have a dashed/dotted style, we will draw the border later via CustomPaint,
    // so we should not include any border in the BoxDecoration.
    final bool useSolidBorder =
        showBorder && appBorderStyle == AppBorderStyle.solid;
    final BoxBorder? effectiveBorder =
        border ?? (useSolidBorder ? _buildBorderFromSideType() : null);

    // --- Determine effective shadows (unchanged) ---
    final List<BoxShadow>? effectiveBoxShadow = _buildShadows();

    // --- Effective decoration (without dashed/dotted border) ---
    final effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: color,
          gradient: gradient,
          image: image,
          border: effectiveBorder, // only included for solid style
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          boxShadow: effectiveBoxShadow,
          shape: shape ?? BoxShape.rectangle,
        );

    // --- Border radius for clipping & custom painter ---
    final effectiveBorderRadius =
        (effectiveDecoration is BoxDecoration &&
            effectiveDecoration.borderRadius != null)
        ? effectiveDecoration.borderRadius
        : borderRadius;
    final BorderRadius finalBorderRadius =
        (effectiveBorderRadius is BorderRadius)
        ? effectiveBorderRadius
        : BorderRadius.circular(12);

    // --- Clip behavior ---
    final effectiveClip = clipContent ? Clip.antiAlias : clipBehavior;

    // --- Inner content (with clipping if needed) ---
    Widget innerContent = Container(
      width: expand ? double.infinity : width,
      height: height,
      constraints: constraints,
      padding: padding,
      alignment: alignment,
      child: effectiveClip != Clip.none
          ? ClipRRect(borderRadius: finalBorderRadius, child: child)
          : child,
    );

    // --- Apply dashed/dotted border if requested (non‑solid) ---
    if (showBorder && appBorderStyle != AppBorderStyle.solid) {
      // Note: dashed/dotted borders currently only work correctly with borderSideType == all.
      // For partial borders (top/bottom/left/right) please use the custom `border` parameter.
      innerContent = CustomPaint(
        painter: _CustomBorderPainter(
          color: borderColor,
          strokeWidth: borderWidth,
          style: appBorderStyle,
          borderRadius: finalBorderRadius.topLeft.x, // uniform radius assumed
          sideType: borderSideType, // passes the side selection
        ),
        child: innerContent,
      );
    }

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
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: effectiveClip,
        child: innerContent,
      );
    }

    // --- Interactive with ripple ---
    if (enableRipple) {
      Widget materialChild = Ink(
        decoration: effectiveDecoration,
        child: InkWell(
          borderRadius: effectiveBorderRadius is BorderRadius
              ? effectiveBorderRadius
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
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: effectiveClip,
        child: innerContent,
      ),
    );
  }

  // Helper to apply margin
  Widget _wrapWithMargin(EdgeInsetsGeometry? margin, Widget child) {
    return margin != null ? Padding(padding: margin, child: child) : child;
  }

  // Build shadows (unchanged) ...
  List<BoxShadow>? _buildShadows() {
    /* ... */
    return null;
  }

  // Build solid border from side type
  BoxBorder _buildBorderFromSideType() {
    final side = BorderSide(
      color: borderColor,
      width: borderWidth,
      style: borderStyle, // solid only
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

// Updated custom painter that respects borderSideType (partial borders)
class _CustomBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final AppBorderStyle style;
  final double borderRadius;
  final BorderSideType sideType;

  _CustomBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.style,
    required this.borderRadius,
    required this.sideType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (style == AppBorderStyle.solid) return;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Build path for the requested sides only
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    final double r = borderRadius;
    final double half = strokeWidth / 2;

    // Helper to add a dashed segment
    void addDashedSegment(Offset start, Offset end) {
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
    }

    // Build the outline segments according to sideType
    if (sideType == BorderSideType.all) {
      path.addRRect(
        RRect.fromLTRBR(half, half, w - half, h - half, Radius.circular(r)),
      );
    } else {
      // For partial borders, we draw only the requested straight edges.
      // Rounded corners are omitted – a more advanced version could include corner arcs.
      if (sideType == BorderSideType.top || sideType == BorderSideType.all) {
        addDashedSegment(Offset(r, half), Offset(w - r, half));
      }
      if (sideType == BorderSideType.right || sideType == BorderSideType.all) {
        addDashedSegment(Offset(w - half, r), Offset(w - half, h - r));
      }
      if (sideType == BorderSideType.bottom || sideType == BorderSideType.all) {
        addDashedSegment(Offset(r, h - half), Offset(w - r, h - half));
      }
      if (sideType == BorderSideType.left || sideType == BorderSideType.all) {
        addDashedSegment(Offset(half, r), Offset(half, h - r));
      }
    }

    // Apply dash pattern (works even if path consists of multiple segments)
    final Path dashedPath = Path();
    final double dashWidth = style == AppBorderStyle.dashed ? 5.0 : 2.0;
    final double dashSpace = style == AppBorderStyle.dashed ? 3.0 : 2.0;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(_CustomBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.style != style ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.sideType != sideType;
}
