import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'maintenance_card.dart';
import 'maintenance_tab_switcher.dart';

class MaintenanceBody extends GetView<MaintenanceController> {
  const MaintenanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MaintenanceTabSwitcher(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.getMaintenanceRequests(),
            child: Obx(() {
              final requests = controller.selectedTabIndex.value == 0
                  ? controller.activeRequests
                  : controller.pastRequests;

              if (requests.isEmpty) {
                return const Center(
                  child: AppEmptyState(
                    title: "No Requests",
                    message: "No maintenance requests found in this category.",
                  ),
                );
              }

              return ListView.builder(
                controller: controller.propertyScrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: requests.length + 1,
                itemBuilder: (context, index) {
                  if (index == requests.length) {
                    return Obx(
                      () => controller.isMoreMaintenanceLoading.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox(height: 80),
                    );
                  }
                  return MaintenanceCard(item: requests[index]);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
