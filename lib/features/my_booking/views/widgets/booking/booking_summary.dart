import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedSummary extends StatelessWidget {
  final BookingSummary summary;
  const BookedSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
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
                  _buildSummaryRow("Booked on:", "${summary.bookedOn}"),
                  _buildDivider(),
                  _buildSummaryRow(
                    "Total Amount:",
                    "\$${summary.totalAmount?.toStringAsFixed(0)}",
                  ),
                  _buildDivider(),
                  _buildSummaryRow(
                    "Paid:",
                    "\$${summary.paidAmount?.toStringAsFixed(0)}",
                  ),
                  _buildDivider(),
                  _buildSummaryRow(
                    "Remaining:",
                    "\$${summary.remainingAmount?.toStringAsFixed(0)}",
                  ),
                  _buildDivider(),
                  _buildSummaryRow(
                    "Status:",
                    "${summary.status}",
                    valueColor: Colors.green,
                  ),
                ],
              ),
            ),

            AppButton(
              text: "Download Receipt",
              icon: Icon(
                Icons.file_download_outlined,
                color: AppColors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
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
        children: [
          AppText(label, color: AppColors.grey.withValues(alpha: 0.7), fontSize: 15),
          AppText(
            value,
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.grey.withValues(alpha: 0.1), height: 1);
  }
}
