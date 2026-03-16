import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_card.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SiteVisitsTab extends GetView<MyBookingController> {
  const SiteVisitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.visitLoading.value && controller.visitList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.visitList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppEmptyState(
                title: "No Visits Found",
                message: "You haven't booked any site visits yet.",
              ),
              const SizedBox(height: 20),
              AppButton(
                text: "Refresh",
                width: 120,
                onPressed: () => controller.getVisitList(),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.getVisitList(),
        child: ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: controller.visitList.length +
              (controller.visitLoading.value && controller.visitList.isNotEmpty
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index == controller.visitList.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final visit = controller.visitList[index];
            return VisitCard(visit: visit);
          },
        ),
      );
    });
  }
}
