import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/features/my_booking/controllers/visit_details_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_booking_summary_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_details_gallery.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_details_map_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_details_review_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_property_info_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_status_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visitor_details_section.dart';

class VisitDetails extends GetView<VisitDetailsController> {
  const VisitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final d = controller.visitDetails.value?.data;
        if (controller.visitLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (d == null) {
          return const Center(child: Text("No details found"));
        }

        return CustomScrollView(
          slivers: [
            VisitDetailsGallery(data: d),
            VisitPropertyInfoSection(property: d.property),
            VisitorDetailsSection(data: d),
            VisitStatusSection(data: d),
            VisitBookingSummarySection(data: d),
            const VisitDetailsMapSection(),
            const VisitDetailsReviewSection(),
            // const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.visitDetails.value == null ||
            controller.visitLoading.value) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  child: AppButton(
                    text: "Cancel visit",
                    onPressed: controller.cancelVisit,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    isBorder: true,
                    borderColor: Colors.red.withValues(alpha: 0.5),
                    // borderRadius: 15,
                    showShadow: false,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AppButton(
                    text: "Buy Property",
                    onPressed: controller.buyProperty,
                    // borderRadius: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
