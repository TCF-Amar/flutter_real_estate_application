import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';


class DeepLinkService extends GetxService {
  final _appLinks = AppLinks();
  final _log = Logger();
  StreamSubscription<Uri>? _sub;

  Uri? pendingUri;

  bool isReady = false;

  Future<DeepLinkService> init() async {
   
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _log.i('[DeepLink] Cold-start URI stored: $initialUri');
      pendingUri = initialUri;
    }

    // ── Warm / hot (app already running) ─────────────────────────────────
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _log.i('[DeepLink] Incoming URI: $uri');
        if (isReady) {
          DeepLinkRouter.handle(uri);
        } else {
          _log.i('[DeepLink] App not ready, storing as pending: $uri');
          pendingUri = uri;
        }
      },
      onError: (Object err, StackTrace st) {
        _log.e('[DeepLink] Stream error: $err', error: err, stackTrace: st);
      },
    );

    return this;
  }

  void consumePending() {
    isReady = true;
    final uri = pendingUri;
    if (uri == null) return;
    pendingUri = null;
    _log.i('[DeepLink] Consuming pending URI: $uri');
    DeepLinkRouter.handle(uri);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}

class DeepLinkRouter {
  DeepLinkRouter._();

  static final _log = Logger();

  static void handle(Uri uri) {
    _log.d('[DeepLink] Routing: $uri');

    String? section;
    String? id;

    if (uri.scheme == 'realestate') {
      section = uri.host;
      id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null; // '55'
    } else {
      final segments = uri.pathSegments;
      if (segments.isEmpty) return;
      section = segments.first;
      id = segments.length > 1 ? segments[1] : null;
    }

    _log.d('[DeepLink] section=$section  id=$id');

    switch (section) {
      case 'property':
        _goToProperty(id);
        break;

      case 'agent':
        _goToAgent(id);
        break;

      default:
        _log.w('[DeepLink] Unhandled section: $section (uri: $uri)');
    }
  }

  static void _goToProperty(String? id) {
    if (id == null || id.isEmpty) {
      _log.w('[DeepLink] Property deep link missing ID');
      return;
    }
    Get.toNamed(AppRoutes.propertyDetails, arguments: id);
  }

  static void _goToAgent(String? id) {
    if (id == null || id.isEmpty) {
      _log.w('[DeepLink] Agent deep link missing ID');
      return;
    }
    Get.toNamed(AppRoutes.agentDetails, arguments: id);
  }
}
