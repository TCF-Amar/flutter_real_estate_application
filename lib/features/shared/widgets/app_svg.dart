import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;

  const AppSvg({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
  });

  String get svgUrl {
    if (path == null || path!.isEmpty) return '';

    if (path!.startsWith('http')) {
      return path!;
    }

    return path!;
  }

  bool get isNetwork => svgUrl.startsWith("http");

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return const SizedBox();
    }

    if (isNetwork) {
      return SvgPicture.network(
        svgUrl,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
      );
    }

    return SvgPicture.asset(
      path!,
      height: height,
      width: width,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
