import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/features/my_booking/views/screens/payment_tracker_screen.dart';

class PaymentTracker extends StatelessWidget {
  final PaymentTrackerModel tracker;
  final BookingDetailsData bookingDetailsData;
  const PaymentTracker({
    super.key,
    required this.tracker,
    required this.bookingDetailsData,
  });

  @override
  Widget build(BuildContext context) {
    final isRent = tracker.type == 'for_rent'; // check the type from backend
    final title = isRent ? "Rent Payment Tracker" : "Installment Tracker";
    final col1Label = isRent ? "Rent" : "Installment";

    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(title, fontSize: 18, fontWeight: FontWeight.w600),
            const SizedBox(height: 16),
            // Header Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4FAF5), // Light green tint for header
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppText(
                      col1Label,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AppText(
                      "Date",
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AppText(
                      "Amount",
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: AppText(
                        "Status",
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Rows
            ...tracker.events.take(3).toList().asMap().entries.map((entry) {
              int index = entry.key;
              PaymentEvent event = entry.value;
              return _buildRow(event, index);
            }),
            ...[
              const SizedBox(height: 16),
              AppButton(
                text: "View all",
                backgroundColor: Colors.transparent,
                textColor: AppColors.textTertiary,
                showShadow: false,
                isBorder: true,
                borderColor: AppColors.textSecondary,
                onPressed: () {
                  Get.to(
                    () => PaymentTrackerScreen(
                      bookingDetailsData: bookingDetailsData,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(PaymentEvent event, int index) {
    bool isPaid = event.status?.toLowerCase() == 'paid';
    Color bgColor = index.isEven ? Colors.white : const Color(0xFFF9FDF9);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(color: bgColor),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              "${event.label}",
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              "${event.date}",
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              "\$${event.amount?.toStringAsFixed(0) ?? 0}",
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isPaid) ...[
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  const AppText(
                    "Paid",
                    color: AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ] else
                  const AppText(
                    "Upcoming",
                    color: Colors.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
