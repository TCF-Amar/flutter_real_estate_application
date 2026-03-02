import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_filter_sheet.dart';

class AgentFilters {
  static void showFilters(BuildContext context, {int tabIndex = 1}) {
    Get.find<AgentController>().initializeFilters();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AgentFilterSheet(),
    );
  }
}
