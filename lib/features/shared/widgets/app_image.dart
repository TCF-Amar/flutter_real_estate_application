import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/environments.dart';

class AppImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? radius;
  final IconData? errorIcon;

  const AppImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius,
    this.errorIcon,
  });

  String get imageUrl {
    if (path == null || path!.isEmpty) return '';

    if (path!.startsWith('http')) {
      return path!;
    }

    return "${Environments.baseUrl}$path";
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(0),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Icon(errorIcon ?? Icons.image_not_supported),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
