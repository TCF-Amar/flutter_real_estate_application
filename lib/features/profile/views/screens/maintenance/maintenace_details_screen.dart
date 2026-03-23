import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'widgets/index.dart';

class MaintenanceDetailsScreen extends GetView<MaintenanceController> {
  final int requestId;
  const MaintenanceDetailsScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMaintenanceDetails(requestId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(title: "Request Detail"),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.maintenanceDetail.value;
        if (detail == null) {
          return const Center(child: AppText("Failed to load details"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyHeader(detail: detail),
              const SizedBox(height: 24),
              RequestInfo(detail: detail),
              const SizedBox(height: 24),
              if (detail.media.images.isNotEmpty ||
                  detail.media.videos.isNotEmpty) ...[
                const AppText("Attached Media", fontWeight: FontWeight.bold),
                const SizedBox(height: 16),
                MediaGallery(detail: detail),
                const SizedBox(height: 24),
              ],
              TechnicianSection(detail: detail),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
