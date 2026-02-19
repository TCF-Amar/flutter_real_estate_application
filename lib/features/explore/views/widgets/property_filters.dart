import 'package:flutter/material.dart';
import 'package:real_estate_app/features/explore/views/widgets/agent_filter_sheet.dart';
import 'package:real_estate_app/features/explore/views/widgets/developer_filter_sheet.dart';
import 'package:real_estate_app/features/explore/views/widgets/project_filter_sheet.dart';

class PropertyFilters {
  static void showFilters(BuildContext context, int tabIndex) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,
      isDismissible: true,

      backgroundColor: Colors.transparent,
      builder: (context) {
        switch (tabIndex) {
          case 0:
            return const ProjectFilterSheet();
          case 1:
            return const AgentFilterSheet();
          case 2:
            return const DeveloperFilterSheet();
          default:
            return const ProjectFilterSheet();
        }
      },
    );
  }
}
