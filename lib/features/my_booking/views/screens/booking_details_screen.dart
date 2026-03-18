import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/my_booking/controllers/booking_details_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booked_property_details.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_summary.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_gallery.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_header_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/latest_update.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/project_overview.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/site_visit_summary.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingDetailsController>();

    return Scaffold(
      body: Obx(() {
        final bookingDetailsData = controller.bookingDetails.value;
        if (controller.failure.value != null) {
          return Center(child: Text(controller.failure.value!.message));
        }
        if (bookingDetailsData == null) {
          return Center(child: Text("No booking details found"));
        }
        if (controller.bookingDetailsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final summary = bookingDetailsData.bookingSummary;
        final propertyDetail = bookingDetailsData.propertyDetail;
        final projectOverview = bookingDetailsData.projectOverview;
        final latestUpdate = bookingDetailsData.latestUpdate;
        final siteVisitSummary = bookingDetailsData.siteVisitSummary;
        // final ownerDetail = bookingDetailsData.ownerDetail;
        // final paymentTracker = bookingDetailsData.paymentTracker;

        if (controller.bookingDetailsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          // appBar: AppBar(title: Text("Booking Details")),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBackButton(),
                ),
                title: AppText.large("Booking Details"),
                centerTitle: true,
                // floating: true,
                // snap: true,
                pinned: true,
                expandedHeight: 280,
                flexibleSpace: BookingHeaderSection(property: propertyDetail),
              ),

              // gallery
              BookingGallery(property: propertyDetail),
              // booked property details
              BookedPropertyDetails(property: propertyDetail),
              // booking summary
              BookedSummary(summary: summary),
              // site visit summary
              if (siteVisitSummary != null)
                SiteVisitSummarySection(summary: siteVisitSummary),

              if (propertyDetail.isUnderConstruction && projectOverview != null)
                ProjectOverviewSection(overview: projectOverview),
              // latest update
              if (latestUpdate != null) LatestUpdateSection(update: latestUpdate),
            ],
          ),
        );
      }),
    );
  }
}
