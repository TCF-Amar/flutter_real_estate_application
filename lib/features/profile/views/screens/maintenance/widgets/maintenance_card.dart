import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_details_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceCard extends StatelessWidget {
  final MaintenanceRequestModel item;
  const MaintenanceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      showBorder: true,
      borderColor: AppColors.grey.withValues(alpha: 0.5),
      margin: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
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
                label: item.status.label,
                color: _getStatusColor(item.status),
                fontSize: 10,
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
                onPressed: () => Get.to(
                    () => MaintenanceDetailsScreen(requestId: item.id)),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, fontSize: 12, fontWeight: FontWeight.w500),
                AppText(subtitle, fontSize: 10, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.open:
      case MaintenanceStatus.assigned:
        return Colors.orange.shade300;
      case MaintenanceStatus.inProgress:
        return Colors.blue.shade300;
      case MaintenanceStatus.completed:
        return Colors.green.shade300;
      case MaintenanceStatus.closed:
        return Colors.red.shade300;
    }
  }
}
