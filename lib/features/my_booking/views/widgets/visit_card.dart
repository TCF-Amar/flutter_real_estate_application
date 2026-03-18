import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking_status_tag.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitCard extends StatelessWidget {
  final VisitResponseData visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      showShadow: true,
      onTap: () {
        Get.toNamed(AppRoutes.visitDetails, arguments: visit.id);
      },
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Row(
        children: [
          // Image Section
          AppContainer(
            width: 130,
            height: 130,
            padding: EdgeInsets.zero,
            // borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(path: visit.property.thumbnail),
            ),
          ),
          const SizedBox(width: 12),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  visit.property.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: AppText(
                        (visit.property.location ?? visit.property.address) ??
                            "",
                        fontSize: 10,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Date & Time
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: visit.preferredDateFormatted ?? "",
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: " | ",
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: visit.timeSlotFormatted?.split("-")[0] ?? "",
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Status Tag
                BookingStatusTag(
                  status: visit.status,
                  label: visit.statusLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
