import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'status_timeline.dart';

class TechnicianSection extends StatelessWidget {
  final MaintenanceDetailModel detail;
  const TechnicianSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final technician = detail.assignedTo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          technician != null ? "Assigned Technician" : "Technician",
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        if (technician == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: AppText(
                "No Technician Assigned Yet...",
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          AppContainer(
            padding: const EdgeInsets.all(12),
            showBorder: true,
            borderColor: AppColors.grey.withValues(alpha: 0.3),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AppImage(
                        path: technician.profileImage,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(technician.name, fontWeight: FontWeight.bold),
                          AppText(
                            detail.category.capitalizeFirst ?? '',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                StatusTimeline(detail: detail),
              ],
            ),
          ),
      ],
    );
  }
}
