import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';

/// A GetxService that handles both cold-start and while-running deep links.
///
/// Cold-start flow:
///   1. [init] captures the launch URI and stores it in [pendingUri]
///   2. The splash screen finishes auth + navigates to /main
///   3. The main screen calls [consumePending] to trigger navigation
///
/// Warm/hot flow: incoming URIs are routed immediately via [uriLinkStream].
class DeepLinkService extends GetxService {
  final _appLinks = AppLinks();
  final _log = Logger();
  StreamSubscription<Uri>? _sub;

  /// Holds a URI from a cold-start launch until the app is ready to route.
  Uri? pendingUri;

  Future<DeepLinkService> init() async {
    // ── Cold-start (app was killed) ───────────────────────────────────────
    // Store the URI — do NOT navigate yet. The app hasn't built its
    // navigation stack yet (splash → auth → main). The main screen
    // calls consumePending() once it is ready.
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _log.i('[DeepLink] Cold-start URI stored: $initialUri');
      pendingUri = initialUri;
    }

    // ── Warm / hot (app already running) ─────────────────────────────────
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _log.i('[DeepLink] Incoming URI: $uri');
        DeepLinkRouter.handle(uri);
      },
      onError: (Object err, StackTrace st) {
        _log.e('[DeepLink] Stream error: $err', error: err, stackTrace: st);
      },
    );

    return this;
  }

  /// Call this once the app is on the main screen and ready to navigate.
  /// Consumes and clears [pendingUri].
  void consumePending() {
    final uri = pendingUri;
    if (uri == null) return;
    pendingUri = null;
    _log.i('[DeepLink] Consuming cold-start URI: $uri');
    DeepLinkRouter.handle(uri);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}

/// Separate router class so routing logic is testable in isolation.
class DeepLinkRouter {
  DeepLinkRouter._();

  static final _log = Logger();

  /// Supported deep link patterns:
  ///
  ///   https://backend-realstate.hktechlabs.com/property/`id`
  ///   realestate://property/`id`
  ///
  ///   https://backend-realstate.hktechlabs.com/agent/`id`
  ///   realestate://agent/`id`
  static void handle(Uri uri) {
    _log.d('[DeepLink] Routing: $uri');

    // URI parsing differs by scheme:
    //
    // Custom scheme → realestate://property/55
    //   uri.host         = 'property'
    //   uri.pathSegments = ['55']
    //
    // HTTPS          → https://domain.com/property/55
    //   uri.host         = 'domain.com'
    //   uri.pathSegments = ['property', '55']
    //
    String? section;
    String? id;

    if (uri.scheme == 'realestate') {
      section = uri.host;                                           // 'property' or 'agent'
      id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null; // '55'
    } else {
      final segments = uri.pathSegments;
      if (segments.isEmpty) return;
      section = segments.first;                                     // 'property' or 'agent'
      id = segments.length > 1 ? segments[1] : null;              // '55'
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
