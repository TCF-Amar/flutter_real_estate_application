import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyHeader extends StatelessWidget {
  final MaintenanceDetailModel detail;
  const PropertyHeader({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(12),
      showBorder: true,
      borderColor: AppColors.grey.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              path: detail.property?.image ?? '',
              height: 180,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      detail.property?.title ?? 'No Title',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: AppText(
                            detail.property?.location ?? '',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppTag(
                label: detail.status.label,
                color: getStatusColor(detail.status),
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color getStatusColor(MaintenanceStatus status) {
  switch (status) {
    case MaintenanceStatus.open:
    case MaintenanceStatus.assigned:
      return Colors.orange.shade300;
    case MaintenanceStatus.in_progress:
      return Colors.blue.shade300;
    case MaintenanceStatus.completed:
      return Colors.green.shade300;
    case MaintenanceStatus.closed:
      return Colors.red.shade300;
  }
}
