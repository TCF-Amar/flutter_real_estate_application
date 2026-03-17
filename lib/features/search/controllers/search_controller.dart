import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';

class AppSearchController extends GetxController {
  final log = Logger();
  final PropertyServices ps = Get.find();
  final _query = "".obs;
  String get query => _query.value;

  final searchController = TextEditingController();
  

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      ps.keywords.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void setQuery(String q) {
    searchController.text = q;
  }

  void search() async {
    await _search();
  }

  Future<void> _search({bool searchMore = false}) async {
    final res = await ps.searchProperties();
  }
}
