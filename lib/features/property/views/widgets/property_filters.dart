import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/views/widgets/project_filter_sheet.dart';

class PropertyFilters {
  static void showFilters(BuildContext context, {int tabIndex = 0}) {
    Get.find<PropertyController>().initializeFilters();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProjectFilterSheet(),
    );
  }
}
