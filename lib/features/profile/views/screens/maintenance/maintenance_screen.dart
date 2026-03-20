import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_request_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

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
            ? const _MaintenanceEmptyBody()
            : const _MaintenanceBody(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: AppButton(
          text: "New Request",
          onPressed: () => Get.to(() => MaintenanceRequestScreen()),
        ),
      ),
    );
  }
}

class _MaintenanceBody extends GetView<MaintenanceController> {
  const _MaintenanceBody();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getMaintenanceRequests(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.activeRequests.isNotEmpty) ...[
              AppText("Active Request", fontWeight: FontWeight.bold),
              const SizedBox(height: 16),
              ...controller.activeRequests.map(
                (e) => _MaintenanceCard(item: e),
              ),
              const SizedBox(height: 24),
            ],
            if (controller.pastRequests.isNotEmpty) ...[
              AppText("Past Request", fontWeight: FontWeight.bold),
              const SizedBox(height: 16),
              ...controller.pastRequests.map((e) => _MaintenanceCard(item: e)),
            ],
          ],
        ),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final MaintenanceRequestModel item;
  const _MaintenanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: AppImage(
                  path: item.property?.image ?? '',
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.property?.title ?? 'No Title',
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      "Req. ID: ${item.requestNumber}",
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              AppTag(
                label: item.status,
                color: _getStatusColor(item.status),
                fontSize: 8,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.access_time,
                title: item.category,
                subtitle: "Issue",
              ),
              const SizedBox(width: 24),
              _buildInfoItem(
                icon: Icons.calendar_today_outlined,
                title: item.createdAt,
                subtitle: "Request Date",
              ),
              const Spacer(),
              AppButton(
                text: "View detail",
                fullWidth: false,
                fontSize: 12,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onPressed: () {
                  // TODO: Navigate to details
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            AppText(title, fontSize: 12, fontWeight: FontWeight.w500),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: AppText(
            subtitle,
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
      case 'pending':
        return Colors.orange.shade300;
      case 'in_progress':
        return Colors.blue.shade300;
      case 'complete':
      case 'completed':
        return Colors.green.shade300;
      default:
        return AppColors.primary;
    }
  }
}

class _MaintenanceEmptyBody extends StatelessWidget {
  const _MaintenanceEmptyBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset(Assets.images.maintenance),
            const SizedBox(height: 20),
            AppText.large("No Maintenance Request Yet"),
            const SizedBox(height: 10),
            AppText(
              "Everything looks great! You haven’t raised any maintenance requests yet. If you face an issue, you can submit a request here.",
              textAlign: .center,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: "New Request",
              onPressed: () {
                Get.to(() => MaintenanceRequestScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
