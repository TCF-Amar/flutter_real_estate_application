import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:real_estate_app/features/developer/view/widgets/developer_filter_sheet.dart';
// import 'package:real_estate_app/features/property/controllers/property_controller.dart';

class DeveloperFilters {
  static void showFilters(BuildContext context, {int tabIndex = 2}) {
    // Get.find<PropertyController>().initializeFilters();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeveloperFilterSheet(),
    );
  }
}
