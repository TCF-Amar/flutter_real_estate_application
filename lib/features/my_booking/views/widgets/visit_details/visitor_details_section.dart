import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitorDetailsSection extends StatelessWidget {
  final VisitData data;
  const VisitorDetailsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderText(
              text: "Visit Information",
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            AppContainer(
              color: AppColors.grey.withValues(alpha: 0.05),
              child: Column(
                children: [
                  _buildVisitInfo(
                    Assets.icons.personSelected,
                    data.fullName,
                    "Full Name",
                  ),
                  _buildVisitInfo(Assets.icons.phone, "${data.phone}", "Phone"),
                  _buildVisitInfo(
                    Assets.icons.calender,
                    "${data.preferredDateFormatted}",
                    "Date",
                  ),
                  _buildVisitInfo(
                    Assets.icons.watch,
                    "${data.timeSlotFormatted}",
                    "Time",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Note: ",
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text:
                        "Carry ID proof for access. The agent will meet you at the entrance.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitInfo(String path, String title, String subtitle) {
    return ListTile(
      leading: AppSvg(path: path, color: AppColors.grey),
      title: AppText(title, fontWeight: FontWeight.w600, fontSize: 14),
      subtitle: AppText(subtitle, fontSize: 10, color: AppColors.textSecondary),
    );
  }
}
