import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/date_time_utils.dart';
import 'package:real_estate_app/features/property/models/project_overview_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class ProjectOverview extends StatelessWidget {
  final ProjectOverviewModel overview;
  const ProjectOverview({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Project Overview",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildProgressBar(context),
                const SizedBox(height: 8),
                _buildStageLabels(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.progresses,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                AppText(
                  overview.percentageComplete ?? "0% Complete",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black.withValues(alpha: 0.5),
                ),
              ],
            ),
            AppText(
              "Status",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              DateTimeUtils.formatMonthYear(overview.possessionDate),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black.withValues(alpha: 0.5),
            ),
            AppText(
              "Possession Date",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final stages = overview.stages;
    if (stages!.isEmpty) return const SizedBox.shrink();

    return Row(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final color = _getStageColor(stage.status);

        return Expanded(
          child: Container(
            height: 8,
            // margin: EdgeInsets.only(right: index == stages.length - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStageLabels() {
    final stages = overview.stages;
    if (stages!.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stages.map((stage) {
        final color = _getLabelColor(stage.status);
        return Expanded(
          child: AppText(
            stage.name ?? "",
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color,
            textAlign: TextAlign.start,
          ),
        );
      }).toList(),
    );
  }

  Color _getStageColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return AppColors.primary;
      case 'in_progress':
      case 'active':
        return Colors.orange;
      default:
        return AppColors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getLabelColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
      case 'active':
        return Colors.orange;
      default:
        return AppColors.grey;
    }
  }
}
