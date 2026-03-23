import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_request_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'widgets/index.dart';

class MaintenanceScreen extends GetView<MaintenanceController> {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: "Maintenance"),
      body: Obx(
        () => controller.isMaintenanceLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.maintenanceList.isEmpty
                ? const MaintenanceEmptyBody()
                : const MaintenanceBody(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: AppButton(
          text: "New Request",
          onPressed: () => Get.to(() => const MaintenanceRequestScreen()),
        ),
      ),
    );
  }
}
