import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/my_booking/models/my_booking_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Get.find<MyBookingController>();
    return AppContainer(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      showShadow: true,
      // showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            height: 140,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                path: "${booking.property?.image}",
                // height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.5,
                child: AppText.large(
                  "${booking.property?.title}",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  // color: AppColors.textSecondary,
                ),
              ),
              // Spacer(),
              SizedBox(width: 10),
              Expanded(
                child: AppText.small(
                  "Booked On: ${booking.bookedOn}",
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          AppText(booking.property?.specs ?? "N/A", fontSize: 12),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(path: Assets.icons.location),
              SizedBox(width: 4),
              Flexible(
                child: AppText(
                  booking.property?.address ?? "N/A",
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          AppText(
            "${booking.isFullyPaid ? booking.paymentStatusLabel : booking.paymentStatusLabel}",
            color: booking.isFullyPaid ? Colors.green : Colors.orange,
          ),
          SizedBox(height: 10),
          AppButton(
            text: "View Details",
            onPressed: () {
              Get.toNamed(AppRoutes.bookingDetails, arguments: booking.id);
            },
          ),
        ],
      ),
    );
  }
}
