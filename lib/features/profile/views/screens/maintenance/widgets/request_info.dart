import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class RequestInfo extends StatelessWidget {
  final MaintenanceDetailModel detail;
  const RequestInfo({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(16),
      color: AppColors.grey.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText("Request info.", fontWeight: FontWeight.bold),
          const SizedBox(height: 16),
          _buildInfoRow("Request ID:", detail.requestNumber, isValueBlue: true),
          const Divider(height: 24),
          _buildInfoRow("Issue Type:", detail.category.capitalizeFirst ?? ''),
          const Divider(height: 24),
          _buildInfoRow("Submitted On:", detail.createdAt),
          const SizedBox(height: 16),
          const AppText("Description:", fontWeight: FontWeight.w500),
          const SizedBox(height: 8),
          AppText(
            detail.description,
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isValueBlue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, color: AppColors.textSecondary),
        AppText(
          value,
          fontWeight: FontWeight.w500,
          color: isValueBlue ? Colors.blue : null,
        ),
      ],
    );
  }
}
