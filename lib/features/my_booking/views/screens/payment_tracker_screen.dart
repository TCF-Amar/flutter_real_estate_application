import 'package:flutter/material.dart';

import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PaymentTrackerScreen extends StatelessWidget {
  final BookingDetailsData bookingDetailsData;

  const PaymentTrackerScreen({super.key, required this.bookingDetailsData});

  @override
  Widget build(BuildContext context) {
    final tracker = bookingDetailsData.paymentTracker;
    final summary = bookingDetailsData.bookingSummary;

    final bool isRent =
        tracker?.type == 'for_rent' ||
        summary.bookingType?.toLowerCase() == 'for rent' ||
        summary.bookingType?.toLowerCase() == 'rental';
    final String title = isRent ? "Rent Tracker" : "Installment Tracker";
    final String sectionTitle = isRent
        ? "Rent Payment Tracker"
        : "Installment Payment Tracker";
    final String col1Label = isRent ? "Rent" : "Installment";
    final String nextPaymentText = summary.nextPaymentDue ?? 'N/A';
    final String nextPaymentLabel =
        summary.nextPaymentLabel ??
        (isRent ? "Next rent due" : "Next installment");

    // Find the first upcoming payment event to get the amount, if possible
    final upcomingEvent = tracker?.events.firstWhere(
      (e) => e.status?.toLowerCase() != 'paid',
      orElse: () => PaymentEvent(amount: 0),
    );

    final num amountToPay =
        (upcomingEvent != null &&
            uppercaseStatus(upcomingEvent.status) != 'PAID' &&
            upcomingEvent.amount != null &&
            upcomingEvent.amount! > 0)
        ? upcomingEvent.amount!
        : (isRent ? (summary.monthlyRent ?? summary.totalAmount ?? 0) : 0);

    return Scaffold(
      appBar: DefaultAppBar(title: title),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80, top: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppContainer(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppText.large(
                        sectionTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Header Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4FAF5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AppText(
                              col1Label,
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              "Date",
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AppText(
                              "Amount",
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: AppText(
                                "Status",
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: AppText(
                                "Receipt",
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rows
                    if (tracker != null)
                      ...tracker.events.asMap().entries.map((entry) {
                        int index = entry.key;
                        PaymentEvent event = entry.value;
                        return _buildRow(event, index);
                      }),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar
          if (summary.status != "fully_paid" && !summary.isFullyPaid)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              nextPaymentText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              nextPaymentLabel,
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        text: "Pay \$${amountToPay.toStringAsFixed(0)} now",
                        width: 160,
                        onPressed: () {
                          // Handle payment
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String uppercaseStatus(String? status) {
    if (status == null) return '';
    return status.toUpperCase();
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
            flex: 3,
            child: AppText(
              "${event.label}",
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              "${event.date}",
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              "\$${event.amount?.toStringAsFixed(0) ?? 0}",
              fontSize: 12,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ] else
                  const AppText(
                    "Upcoming",
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: isPaid && event.receiptUrl != null
                  ? GestureDetector(
                      onTap: () {
                        // Open receipt
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.download_outlined,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          const AppText(
                            "Download",
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    )
                  : const AppText("-", color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
