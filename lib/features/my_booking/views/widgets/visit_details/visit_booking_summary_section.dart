import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitBookingSummarySection extends StatelessWidget {
  final VisitData data;
  const VisitBookingSummarySection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             AppText.large(
              "Booking Summary",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            AppContainer(
              color: const Color(
                0xFFFFF9EE,
              ), // Light yellowish background from reference
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildSummaryRow("Booking ID:", "#VIS${data.id}"),
                  const Divider(color: Color(0xFFF0E6D2), height: 1),
                  _buildSummaryRow(
                    "Booked On:",
                    data.createdAt?.split('T').first ?? "N/A",
                  ),
                  const Divider(color: Color(0xFFF0E6D2), height: 1),
                  _buildSummaryRow(
                    "Property Type:",
                    data.property?.propertyCategory ?? "N/A",
                  ),
                  const Divider(color: Color(0xFFF0E6D2), height: 1),
                  _buildSummaryRow(
                    "Configuration:",
                    data.property!.configurationName!.isNotEmpty
                        ? "${data.property!.configurationName} "
                        : "N/A",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 12,
          ),
          AppText(
            value,
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
