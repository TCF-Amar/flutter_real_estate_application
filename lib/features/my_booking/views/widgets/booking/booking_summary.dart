import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedSummary extends StatelessWidget {
  final BookingSummary summary;
  final BookedPropertyDetail property;
  const BookedSummary({
    super.key,
    required this.summary,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = summary.status == "fully_paid" || summary.isFullyPaid;
    final bool isRental =
        summary.bookingType?.toLowerCase() == 'for rent' ||
        summary.bookingType?.toLowerCase() == 'rental';

    String leaseTermText = summary.leaseTerm != null
        ? "${summary.leaseTerm} Months"
        : "";
    if (summary.leaseStartDate != null &&
        summary.leaseEndDate != null &&
        summary.leaseStartDate!.isNotEmpty) {
      leaseTermText += " (${summary.leaseStartDate} - ${summary.leaseEndDate})";
    }

    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Booking Summary",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            AppContainer(
              color: const Color(
                0xFFFFF9F0,
              ), // Light cream background from image
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildSummaryRow("Booking ID:", "#${summary.bookingId}"),
                  _buildDivider(),
                  _buildSummaryRow("Booked on:", "${summary.bookedOn ?? ''}"),
                  _buildDivider(),
                  if (isRental) ...[
                    _buildSummaryRow(
                      "Monthly Rent:",
                      "\$${(summary.monthlyRent ?? summary.totalAmount ?? 0).toStringAsFixed(0)}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Security Deposit:",
                      "\$${summary.securityDeposit?.toStringAsFixed(0) ?? 0}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow("Lease Term:", leaseTermText),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Next Rent Due:",
                      "${summary.nextPaymentDue ?? ''}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Payment Status:", // Using status if paymentStatus is missing
                      summary.paymentStatus ?? summary.status ?? '',
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Total Paid Till Date:",
                      "\$${summary.paidAmount?.toStringAsFixed(0) ?? 0}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Remaining Lease Payments:",
                      "${summary.remainingLeasePayments ?? 0}",
                    ),
                  ] else ...[
                    _buildSummaryRow(
                      "Total Amount:",
                      "\$${summary.totalAmount?.toStringAsFixed(0) ?? 0}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Paid:",
                      "\$${summary.paidAmount?.toStringAsFixed(0) ?? 0}",
                    ),
                    _buildDivider(),
                    _buildSummaryRow(
                      "Remaining:",
                      "\$${summary.remainingAmount?.toStringAsFixed(0) ?? 0}",
                    ),
                    _buildDivider(),
                    if (isPaid)
                      _buildSummaryRow(
                        "Status:",
                        "Full Paid",
                        valueColor: Colors.green,
                      )
                    else
                      _buildSummaryRow(
                        "Next Installment Due:",
                        summary.nextPaymentDue ?? '',
                      ),
                  ],
                ],
              ),
            ),
            if (summary.percentageComplete != null &&
                summary.percentage != null &&
                !isPaid)
              AppContainer(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText("${summary.percentageComplete}"),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: summary.percentage! / 100,
                      backgroundColor: AppColors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      minHeight: 10,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 16),
            if (isPaid)
              AppButton(
                text: "Download Receipt",
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: AppColors.white,
                  size: 20,
                ),
                onPressed: () {},
              )
            else if (isRental)
              AppButton(text: "Pay Rent", onPressed: () {})
            else
              AppButton(text: "Pay Installment", onPressed: () {}),
            const SizedBox(height: 12),
            AppButton(
              text: "View Document",
              backgroundColor: Colors.transparent,
              textColor: AppColors.textTertiary,
              showShadow: false,
              isBorder: true,
              borderColor: AppColors.textSecondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppText(
              label,
              color: AppColors.grey.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          AppText(
            value,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: valueColor ?? AppColors.textPrimary,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.grey.withValues(alpha: 0.1), height: 1);
  }
}
