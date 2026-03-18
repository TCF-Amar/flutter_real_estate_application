import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ProjectOverviewSection extends StatelessWidget {
  final ProjectOverview overview;
  const ProjectOverviewSection({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Project Overview",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            AppContainer(
              color: const Color(0xFFFFF9F0), // Matching the cream background
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(
                        icon: Assets.icons.progresses,
                        value: overview.percentageComplete ?? '0',
                        label: "Status",
                        iconColor: Colors.deepPurpleAccent,
                      ),
                      _buildInfoColumn(
                        value: overview.possessionDate ?? 'N/A',
                        label: "Possession Date",
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: overview.stages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stage = entry.value;
                      final isLast = index == overview.stages.length - 1;

                      return Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 6,
                              margin: EdgeInsets.only(right: isLast ? 0 : 4),
                              decoration: BoxDecoration(
                                color: _getStageColor(stage.status),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppText(
                              stage.name ?? '',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStageColor(stage.status),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({
    String? icon,
    required String value,
    required String label,
    Color? iconColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppSvg(path: icon, color: iconColor),
              const SizedBox(width: 8),
            ],
            AppText(
              value,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(label, fontSize: 12, color: AppColors.textSecondary),
      ],
    );
  }

  Color _getStageColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey.shade300;
    }
  }
}
