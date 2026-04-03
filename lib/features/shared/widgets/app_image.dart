import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/features/shared/widgets/app_svg.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

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
            borderRadius: radius ?? BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: url,
              height: height,
              width: width,
              fit: fit,
              errorWidget: (_, __, ___) => _errorPlaceholder(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  _buildSkeletonLoader(),
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
      child: _buildErrorChild(),
    );
  }

  Widget _buildErrorChild() {
    if (errorImagePath != null && errorImagePath!.isNotEmpty) {
      if (errorImagePath!.endsWith('.svg')) {
        return AppSvg(path: errorImagePath!);
      }
      return Icon(Icons.image_not_supported, color: Colors.grey.shade400);
    }
    return Icon(
      errorIcon ?? Icons.image_not_supported,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildSkeletonLoader() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.zero,
        color: Colors.grey.shade300,
      ),
      child: _shimmer(),
    );
  }

  Widget _shimmer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.zero,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
        ),
      ),
    );
  }
}
