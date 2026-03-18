import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SiteVisitSummarySection extends StatelessWidget {
  final SiteVisitSummary summary;
  const SiteVisitSummarySection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Site Visit Summary",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            AppContainer(
              color: AppColors.grey.withValues(alpha: 0.04),
              padding: const EdgeInsets.all(24),
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  _buildSummaryItem(
                    icon: Icons.person_outline,
                    value: summary.agentName ?? 'N/A',
                    label: "Agent name",
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryItem(
                    icon: Icons.phone_outlined,
                    value: summary.agentPhone ?? 'N/A',
                    label: "Contact",
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryItem(
                    icon: Icons.chat_bubble_outline,
                    value: summary.feedback ?? 'N/A',
                    label: "Feedback",
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryItem(
                    icon: Icons.calendar_today_outlined,
                    value: "Completed on ${summary.completedOn ?? summary.date ?? 'N/A'}",
                    label: "Site visit",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.grey, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                value,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              AppText(
                label,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
