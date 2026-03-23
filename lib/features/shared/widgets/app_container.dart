import 'dart:ui';

import 'package:flutter/material.dart';
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
  final Decoration? decoration;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? image;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BlendMode? backgroundBlendMode; // ✅ now actually used
  final BoxShape? shape;

  // ----- Simplified border controls -----
  final bool showBorder;
  final BorderSideType borderSideType;
  final Color borderColor;
  final double borderWidth;
  final AppBorderStyle appBorderStyle;

  // ----- Simplified shadow controls -----
  final bool showShadow;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final double? shadowSpreadRadius;
  final double? elevation; // ✅ now fed into shadow builder

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
    this.showBorder = false,
    this.borderSideType = BorderSideType.all,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.appBorderStyle = AppBorderStyle.solid,
    this.showShadow = true,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.shadowSpreadRadius,
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

  // ── Helpers ──────────────────────────────────────────────────────────────

  BorderRadius get _finalBorderRadius {
    if (borderRadius is BorderRadius) return borderRadius as BorderRadius;
    return BorderRadius.circular(12);
  }

  double? get _effectiveWidth => expand ? double.infinity : width;

  // ✅ Fixed: actually reads all shadow properties including elevation
  List<BoxShadow>? _buildShadows() {
    // Caller supplied explicit list — use it as-is
    if (boxShadow != null) return boxShadow;

    if (!showShadow) return null;

    // elevation acts as a quick shorthand blur
    final double blur =
        shadowBlurRadius ?? (elevation != null ? elevation! * 2 : 0);
    if (blur <= 0 && shadowSpreadRadius == null) return null;

    return [
      BoxShadow(
        color: shadowColor ?? Colors.black.withValues(alpha: 0.12),
        blurRadius: blur,
        offset: shadowOffset ?? const Offset(0, 2),
        spreadRadius: shadowSpreadRadius ?? 0,
      ),
    ];
  }

  BoxBorder _buildBorderFromSideType() {
    final side = BorderSide(color: borderColor, width: borderWidth);
    switch (borderSideType) {
      case BorderSideType.all:
        return Border.fromBorderSide(side);
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

  Decoration _buildDecoration() {
    if (decoration != null) return decoration!;

    final bool useSolidBorder =
        showBorder && appBorderStyle == AppBorderStyle.solid;

    return BoxDecoration(
      color: color,
      gradient: gradient,
      image: image,
      backgroundBlendMode: backgroundBlendMode, // ✅ applied
      border: border ?? (useSolidBorder ? _buildBorderFromSideType() : null),
      borderRadius: shape == BoxShape.circle ? null : borderRadius,
      boxShadow: _buildShadows(),
      shape: shape ?? BoxShape.rectangle,
    );
  }

  // ✅ Fixed: inner widget only handles padding + alignment + clipping,
  //           NOT width/height/constraints (those belong on the outer container)
  Widget _buildInner() {
    Widget content = child ?? const SizedBox.shrink();

    if (clipContent) {
      content = ClipRRect(borderRadius: _finalBorderRadius, child: content);
    }

    // Wrap with dashed/dotted painter if needed
    if (showBorder && appBorderStyle != AppBorderStyle.solid) {
      content = CustomPaint(
        painter: _CustomBorderPainter(
          color: borderColor,
          strokeWidth: borderWidth,
          style: appBorderStyle,
          borderRadius: _finalBorderRadius.topLeft.x,
          sideType: borderSideType,
        ),
        child: content,
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: alignment != null
          ? Align(alignment: alignment!, child: content)
          : content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = _buildDecoration();
    final effectiveClip = clipContent ? Clip.antiAlias : clipBehavior;
    final bool isInteractive =
        onTap != null || onLongPress != null || onDoubleTap != null;

    // ── Static (no interaction) ───────────────────────────────────────────
    if (!isInteractive) {
      return Container(
        width: _effectiveWidth,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration, // applied once here only ✅
        clipBehavior: effectiveClip,
        child: _buildInner(),
      );
    }

    // ── Interactive with ripple ───────────────────────────────────────────
    if (enableRipple) {
      return _wrapWithMargin(
        margin,
        SizedBox(
          width: _effectiveWidth, // ✅ expand respected on ripple path
          height: height,
          child: Material(
            color: Colors.transparent,
            clipBehavior: effectiveClip,
            borderRadius: _finalBorderRadius,
            child: Ink(
              decoration: effectiveDecoration,
              child: InkWell(
                borderRadius: _finalBorderRadius,
                onTap: onTap,
                onLongPress: onLongPress,
                onDoubleTap: onDoubleTap,
                splashColor: splashColor,
                highlightColor: highlightColor,
                splashFactory: splashFactory,
                child: _buildInner(),
              ),
            ),
          ),
        ),
      );
    }

    // ── Interactive without ripple ────────────────────────────────────────
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: Container(
        width: _effectiveWidth,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: effectiveClip,
        child: _buildInner(),
      ),
    );
  }

  Widget _wrapWithMargin(EdgeInsetsGeometry? margin, Widget child) =>
      margin != null ? Padding(padding: margin, child: child) : child;
}

// ── Custom dashed/dotted border painter ──────────────────────────────────────
class _CustomBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final AppBorderStyle style;
  final double borderRadius;
  final BorderSideType sideType;

  const _CustomBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.style,
    required this.borderRadius,
    required this.sideType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (style == AppBorderStyle.solid) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = _buildPath(size);
    final dashedPath = _applyDash(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _buildPath(Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    final double r = borderRadius;
    final double half = strokeWidth / 2;

    if (sideType == BorderSideType.all) {
      path.addRRect(
        RRect.fromLTRBR(half, half, w - half, h - half, Radius.circular(r)),
      );
    } else {
      // ✅ Fixed: no redundant `|| sideType == BorderSideType.all` inside else
      if (sideType == BorderSideType.top) {
        path.moveTo(r, half);
        path.lineTo(w - r, half);
      }
      if (sideType == BorderSideType.right) {
        path.moveTo(w - half, r);
        path.lineTo(w - half, h - r);
      }
      if (sideType == BorderSideType.bottom) {
        path.moveTo(r, h - half);
        path.lineTo(w - r, h - half);
      }
      if (sideType == BorderSideType.left) {
        path.moveTo(half, r);
        path.lineTo(half, h - r);
      }
    }
    return path;
  }

  Path _applyDash(Path source) {
    final double dashWidth = style == AppBorderStyle.dashed ? 5.0 : 2.0;
    final double dashSpace = style == AppBorderStyle.dashed ? 3.0 : 2.0;
    final Path result = Path();

    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        result.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(_CustomBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.style != style ||
      old.borderRadius != borderRadius ||
      old.sideType != sideType;
}
