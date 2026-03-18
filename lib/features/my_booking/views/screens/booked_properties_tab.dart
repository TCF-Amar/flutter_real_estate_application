import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking_card.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedPropertiesTab extends StatelessWidget {
  BookedPropertiesTab({super.key});
  final MyBookingController controller = Get.find<MyBookingController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await controller.refreshBooking(),
      child: Obx(() {
        if (controller.bookingLoading.value && controller.myBookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myBookings.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              AppEmptyState(
                title: "No Bookings Found",
                message: "You haven't made any property bookings yet.",
              ),
            ],
          );
        }

        return ListView.builder(
          controller: controller.bookingScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.myBookings.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.myBookings.length) {
              return Obx(
                () => controller.bookingLoadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox(height: 80),
              );
            }
            final booking = controller.myBookings[index];
            return BookingCard(booking: booking);
          },
        );
      }),
    );
  }
}
