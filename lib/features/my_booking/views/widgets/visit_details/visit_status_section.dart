import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitStatusSection extends StatelessWidget {
  final VisitData data;
  const VisitStatusSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Visit Status",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            AppContainer(
              color: AppColors.success.withValues(alpha: 0.05),
              child: Column(
                children: [
                  Row(
                    children: [
                      const AppText("Status:"),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          if (data.status == "complete")
                            const Icon(Icons.check_circle, color: Colors.green),
                          if (data.status == "canceled")
                            const Icon(Icons.cancel, color: Colors.red),
                          if (data.status == "requested")
                            AppSvg(path: Assets.icons.boxTimer),
                          const SizedBox(width: 10),
                          AppText(
                            data.statusLabel.toString(),
                            color: data.status == "complete"
                                ? Colors.green
                                : data.status == "canceled"
                                ? Colors.red
                                : Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      AppText("Next Step: ", fontSize: 10),
                      SizedBox(width: 10),
                      AppText(
                        "Reach the property 15 mins before time.",
                        fontSize: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
