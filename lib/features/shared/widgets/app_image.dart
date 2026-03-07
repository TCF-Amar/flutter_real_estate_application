import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/features/shared/widgets/app_svg.dart';

class AppImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? radius;
  final IconData? errorIcon;
  final String? errorImagePath;
  final bool? isProfileImage;
  final double? profileImageRadius;

  const AppImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.radius,
    this.errorIcon,
    this.errorImagePath,
    this.isProfileImage = false,
    this.profileImageRadius = 22,
  });

  String _imageUrl() {
    if (path == null || path!.isEmpty) return '';

    if (path!.startsWith('http')) return path!;

    return "${Environments.baseUrl}$path";
  }

  @override
  Widget build(BuildContext context) {
    // print(path);
    final url = _imageUrl();

    if (url.isEmpty) {
      return _errorPlaceholder();
    }

    return isProfileImage == true
        ? CircleAvatar(
            radius: profileImageRadius,
            backgroundImage: NetworkImage(url),
          )
        : ClipRRect(
            borderRadius: radius ?? BorderRadius.zero,
            child: CachedNetworkImage(
              imageUrl: url,
              height: height,
              width: width,
              fit: fit,
              errorWidget: (_, __, ___) => _errorPlaceholder(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
            ),
          );
  }

  Widget _errorPlaceholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.zero,
        color: Colors.grey.shade200,
      ),
      alignment: Alignment.center,
      child: errorImagePath != null && errorImagePath!.isNotEmpty
          ? AppSvg(path: errorImagePath!)
          : Icon(
              errorIcon ?? Icons.image_not_supported,
              color: Colors.grey.shade400,
            ),
    );
  }
}
