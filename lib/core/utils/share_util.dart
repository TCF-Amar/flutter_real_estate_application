import 'package:flutter/material.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtil {
  ShareUtil._();

  /// 🔥 Main share function
  static Future<void> shareProperty(ShareData data) async {
    try {
      final text = _buildText(data);

      final params = ShareParams(text: text, subject: data.title);

      await SharePlus.instance.share(params);
    } catch (e) {
      debugPrint("Share Error: $e");
    }
  }

  /// 🔹 Only URL share
  static Future<void> shareUrl(String url) async {
    final params = ShareParams(text: url);
    await SharePlus.instance.share(params);
  }

  /// 🔹 Format text
  static String _buildText(ShareData data) {
    return '''
${data.title}

${data.message}

🔗 View Property:
${data.url}
''';
  }
}
