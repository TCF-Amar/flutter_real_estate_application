import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final String? semanticsLabel;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppSvg({
    super.key,
    this.path,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticsLabel,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isNetwork => path != null && path!.startsWith('http');

  ColorFilter? _colorFilter(Color? c) =>
      c != null ? ColorFilter.mode(c, BlendMode.srcIn) : null;

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) return const SizedBox.shrink();

    final effectiveW = width;
    final effectiveH = height;
    final effectiveC = color;

    if (_isNetwork) {
      return SvgPicture.network(
        path!,
        height: effectiveH,
        width: effectiveW,
        fit: fit,
        colorFilter: _colorFilter(effectiveC),
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (_) =>
            placeholder ??
            SizedBox(
              height: effectiveH ?? 16,
              width: effectiveW ?? 16,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
      );
    }

    return Builder(
      builder: (context) {
        try {
          return SvgPicture.asset(
            path!,
            height: effectiveH,
            width: effectiveW,
            fit: fit,
            colorFilter: _colorFilter(effectiveC),
            semanticsLabel: semanticsLabel,
          );
        } catch (_) {
          return errorWidget ??
              SizedBox(height: effectiveH ?? 24, width: effectiveW ?? 24);
        }
      },
    );
  }
}
