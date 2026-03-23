import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class StatusTimeline extends StatelessWidget {
  final MaintenanceDetailModel detail;
  const StatusTimeline({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TimelineItem(
                subtitle: "Assigned",
                title: detail.scheduledDate ?? detail.createdAt,
                icon: AppSvg(path: Assets.icons.taskAssigned),
                isCompleted: detail.status != MaintenanceStatus.open,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TimelineItem(
                subtitle: "Start Working",
                title: detail.updatedAt,
                icon: AppSvg(path: Assets.icons.workingStart),
                isCompleted:
                    detail.status == MaintenanceStatus.in_progress ||
                    detail.status == MaintenanceStatus.completed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TimelineItem(
          subtitle: detail.completedDate != null ? "Complete" : "Pending",
          title: detail.completedDate ?? 'Not Completed',
          icon: detail.completedDate != null
              ? AppSvg(path: Assets.icons.workingComplete)
              : AppSvg(path: Assets.icons.pana),
          isCompleted: detail.status == MaintenanceStatus.completed,
          isLast: true,
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppSvg icon;
  final bool isCompleted;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: 13,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                color: isCompleted ? null : AppColors.textSecondary,
              ),
              if (subtitle.isNotEmpty)
                AppText(subtitle, fontSize: 11, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}
