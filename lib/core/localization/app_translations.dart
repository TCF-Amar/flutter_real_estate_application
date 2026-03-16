import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  final Map<String, Map<String, String>> _keys;

  AppTranslations(this._keys);

  @override
  Map<String, Map<String, String>> get keys => _keys;

  static Future<AppTranslations> load() async {
    final enString = await rootBundle.loadString('assets/translations/en.json');
    final arString = await rootBundle.loadString('assets/translations/ar.json');

    final enMap = Map<String, String>.from(json.decode(enString));
    final arMap = Map<String, String>.from(json.decode(arString));

    return AppTranslations({'en': enMap, 'ar': arMap});
  }
}
