import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:real_estate_app/core/constants/environments.dart';

class AppPanoramaView extends StatelessWidget {
  final String? path;

  const AppPanoramaView({super.key, this.path});

  String get imageUrl {
    if (path == null || path!.isEmpty) return '';

    if (path!.startsWith('http')) {
      return path!;
    }

    return "${Environments.baseUrl}$path";
  }

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return const SizedBox();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: PanoramaViewer(child: Image.network(imageUrl, fit: BoxFit.cover)),
    );
  }
}
