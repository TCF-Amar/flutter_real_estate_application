import 'package:flutter/material.dart';

/// A customizable text widget with built‑in large, medium (default), and small variants.
/// Now with complete shadow control.
class AppText extends StatelessWidget {
  final String text;
  final AppTextSize size;
  final TextStyle? themeStyle;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final Paint? foreground;
  final Paint? background;

  // ----- Shadow control -----
  final bool showShadow; // master switch
  final List<Shadow>? shadows; // full custom shadows
  final Color? shadowColor; // simplified single shadow
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final double?
  shadowSpreadRadius; // Note: Shadow doesn't have spread, but we keep for consistency; spread is ignored in Shadow.

  final List<FontFeature>? fontFeatures;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final Color? selectionColor;
  final bool allowTextScaling;

  /// Default constructor – uses medium size (maps to [TextTheme.bodyLarge]).
  const AppText(
    this.text, {
    super.key,
    this.size = AppTextSize.medium,
    this.themeStyle,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.foreground,
    this.background,
    // Shadow params
    this.showShadow = true,
    this.shadows,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.shadowSpreadRadius,
    this.fontFeatures,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.selectionColor,
    this.allowTextScaling = true,
  });

  /// Large text variant – maps to [TextTheme.headlineSmall].
  factory AppText.large(
    String text, {
    Key? key,
    TextStyle? themeStyle,
    TextStyle? style,
    Color? color,
    double? fontSize = 22,
    FontWeight? fontWeight = FontWeight.w500,
    String? fontFamily,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    Paint? foreground,
    Paint? background,
    bool showShadow = true,
    List<Shadow>? shadows,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    double? shadowSpreadRadius,
    List<FontFeature>? fontFeatures,
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Locale? locale,
    StrutStyle? strutStyle,
    TextWidthBasis? textWidthBasis,
    Color? selectionColor,
    bool allowTextScaling = true,
  }) {
    return AppText(
      text,
      key: key,
      size: AppTextSize.large,
      themeStyle: themeStyle,
      style: style,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      foreground: foreground,
      background: background,
      showShadow: showShadow,
      shadows: shadows,
      shadowColor: shadowColor,
      shadowBlurRadius: shadowBlurRadius,
      shadowOffset: shadowOffset,
      shadowSpreadRadius: shadowSpreadRadius,
      fontFeatures: fontFeatures,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      selectionColor: selectionColor,
      allowTextScaling: allowTextScaling,
    );
  }

  /// Small text variant – maps to [TextTheme.bodySmall].
  factory AppText.small(
    String text, {
    Key? key,
    TextStyle? themeStyle,
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    Paint? foreground,
    Paint? background,
    bool showShadow = true,
    List<Shadow>? shadows,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    double? shadowSpreadRadius,
    List<FontFeature>? fontFeatures,
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    Locale? locale,
    StrutStyle? strutStyle,
    TextWidthBasis? textWidthBasis,
    Color? selectionColor,
    bool allowTextScaling = true,
  }) {
    return AppText(
      text,
      key: key,
      size: AppTextSize.small,
      themeStyle: themeStyle,
      style: style,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      foreground: foreground,
      background: background,
      showShadow: showShadow,
      shadows: shadows,
      shadowColor: shadowColor,
      shadowBlurRadius: shadowBlurRadius,
      shadowOffset: shadowOffset,
      shadowSpreadRadius: shadowSpreadRadius,
      fontFeatures: fontFeatures,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      selectionColor: selectionColor,
      allowTextScaling: allowTextScaling,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Map size to a theme style
    final TextStyle? baseThemeStyle = switch (size) {
      AppTextSize.large => theme.textTheme.headlineSmall,
      AppTextSize.medium => theme.textTheme.bodyLarge,
      AppTextSize.small => theme.textTheme.bodySmall,
    };

    final baseStyle = themeStyle ?? baseThemeStyle;
    final mergedStyle = baseStyle?.merge(style) ?? style;

    // Compute effective shadows
    final List<Shadow>? effectiveShadows = _buildShadows();

    final effectiveStyle = mergedStyle?.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      foreground: foreground,
      background: background,
      shadows: effectiveShadows,
      fontFeatures: fontFeatures,
    );

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      selectionColor: selectionColor,
    );
  }

  // Build shadows based on simplified parameters, shadows list, or none
  List<Shadow>? _buildShadows() {
    if (!showShadow) return null;

    // 1. If explicit shadows list is provided, use it
    if (shadows != null) return shadows;

    // 2. If any simple shadow param is provided, create a single Shadow
    final hasSimpleShadow =
        shadowColor != null ||
        shadowBlurRadius != null ||
        shadowOffset != null ||
        shadowSpreadRadius != null; // spread is ignored for Shadow

    if (hasSimpleShadow) {
      return [
        Shadow(
          color: shadowColor ?? Colors.black.withValues(alpha: 0.15),
          blurRadius: shadowBlurRadius ?? 4.0,
          offset: shadowOffset ?? const Offset(0, 2),
        ),
      ];
    }

    // 3. No shadow
    return null;
  }
}

/// Semantic size variants.
enum AppTextSize { large, medium, small }
