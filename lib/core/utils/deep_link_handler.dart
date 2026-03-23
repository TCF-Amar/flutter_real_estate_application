import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';

class DeepLinkHandler {
  final _appLinks = AppLinks();

  Future<void> init() async {
    // Check initial link
    final initialUri = await _appLinks.getInitialLink();
    debugPrint("initialUri: $initialUri");
    if (initialUri != null) {
      _handleLink(initialUri.toString());
    }

    // Subscribe to all upcoming links
    _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri.toString());
    });
  }

  void _handleLink(String? link) {
    if (link == null) return;

    final uri = Uri.parse(link);
    final path = uri.path;
    debugPrint("path: $path");

    if (path.contains("/property")) {
      final segments = path.split("/");
      // Path format: /property/:id
      if (segments.length >= 3) {
        final id = segments[2];
        Get.toNamed(AppRoutes.propertyDetails, arguments: {"id": id});
      }
    }
  }
}
