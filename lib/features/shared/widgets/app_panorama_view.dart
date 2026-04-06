import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:real_estate_app/core/constants/environments.dart';

class AppPanoramaView extends StatefulWidget {
  final String? path;

  const AppPanoramaView({super.key, this.path});

  @override
  State<AppPanoramaView> createState() => _AppPanoramaViewState();
}

class _AppPanoramaViewState extends State<AppPanoramaView> {
  // late bool _isLoading;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    // _isLoading = true;
    _hasError = false;
  }

  String get imageUrl {
    if (widget.path == null || widget.path!.isEmpty) return '';

    if (widget.path!.startsWith('http')) {
      return widget.path!;
    }

    return "${Environments.baseUrl}${widget.path}";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path == null || widget.path!.isEmpty) {
      return const SizedBox();
    }

    return Material(
      color: Colors.black,
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.close, size: 30, color: Colors.white),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load panorama',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : PanoramaViewer(
                      // maxZoom: 200,
                      // zoom: 100,
                      // minZoom: 100,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {}
                            });
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => _hasError = true);
                            }
                          });
                          return const SizedBox();
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
