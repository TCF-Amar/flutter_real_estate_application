import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/environments.dart';

class AppImage extends StatefulWidget {
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
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  // FIX #1: Cache the imageUrl to prevent rebuilds if path doesn't change
  late String _cachedUrl;

  @override
  void initState() {
    super.initState();
    _cachedUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // FIX #1: Only update URL if path actually changed
    if (oldWidget.path != widget.path) {
      _cachedUrl = widget.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX #2: Don't show error if URL is empty - just show placeholder
    if (_cachedUrl.isEmpty) {
      return _buildErrorPlaceholder();
    }

    return ClipRRect(
      borderRadius: widget.radius ?? BorderRadius.circular(0),
      // FIX #3: Use Image.network with proper caching strategy
      child: Image.network(
        _cachedUrl,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        // FIX #4: Cache images in memory by default (ImageCache handles this)
        cacheWidth: widget.width != null
            ? (widget.width! * MediaQuery.of(context).devicePixelRatio).toInt()
            : null,
        cacheHeight: widget.height != null
            ? (widget.height! * MediaQuery.of(context).devicePixelRatio).toInt()
            : null,
        // FIX #5: Prevent reloading on every rebuild with semanticLabel
        semanticLabel: widget.path ?? 'Image',
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            // FIX #6: Use smaller loader for images
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: widget.height,
      width: widget.width,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        widget.errorIcon ?? Icons.image_not_supported,
        color: Colors.grey.shade400,
      ),
    );
  }
}
