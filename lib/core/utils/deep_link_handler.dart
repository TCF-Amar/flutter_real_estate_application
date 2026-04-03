// This file is kept for backward compatibility.
// All routing logic has been consolidated into DeepLinkRouter inside
// deep_link_service.dart. Delegate here to avoid breaking any existing callers.

import 'package:real_estate_app/core/services/deep_link_service.dart';

class DeepLinkHandler {
  DeepLinkHandler._();

  static void handle(Uri uri) => DeepLinkRouter.handle(uri);
}
