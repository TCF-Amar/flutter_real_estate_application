import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/booking_details_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booked_property_details.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_summary.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_gallery.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booking_header_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/latest_update.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/owner_detail_section.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/payment_tracker.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/project_overview.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/site_visit_summary.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/contact_support_section.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_request_screen.dart';
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

        if (controller.bookingDetailsLoading) {
          return Center(child: CircularProgressIndicator());
        }
        // if (bookingDetailsData == null) {
        //   return Center(child: Text("No booking details found"));
        // }
        final summary = bookingDetailsData?.bookingSummary;
        final propertyDetail = bookingDetailsData?.propertyDetail;
        final projectOverview = bookingDetailsData?.projectOverview;
        final latestUpdate = bookingDetailsData?.latestUpdate;
        final siteVisitSummary = bookingDetailsData?.siteVisitSummary;
        final ownerDetail = bookingDetailsData?.ownerDetail;
        final paymentTracker = bookingDetailsData?.paymentTracker;

        return Scaffold(
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
                flexibleSpace: BookingHeaderSection(property: propertyDetail!),
              ),

              // gallery
              BookingGallery(property: propertyDetail),
              // booked property details
              BookedPropertyDetails(property: propertyDetail),

              // booking summary
              // site visit summary
              if (propertyDetail.isUnderConstruction && projectOverview != null)
                ProjectOverviewSection(overview: projectOverview),
              // latest update
              if (latestUpdate != null && propertyDetail.isUnderConstruction)
                LatestUpdateSection(update: latestUpdate),
              BookedSummary(summary: summary!, property: propertyDetail),

              if (paymentTracker != null && paymentTracker.events.isNotEmpty)
                PaymentTracker(
                  tracker: paymentTracker,
                  bookingDetailsData: bookingDetailsData!,
                ),

              if (siteVisitSummary != null)
                SiteVisitSummarySection(summary: siteVisitSummary),

              if (ownerDetail != null) OwnerDetailSection(owner: ownerDetail),

              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    // AppSnackbar.error("Maintenance");
                    Get.to(
                      () => MaintenanceRequestScreen(
                        propertyId: propertyDetail.id,
                        propertyTitle: propertyDetail.title,
                      ),
                    );
                  },
                  child: AppContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      // vertical: 20,
                    ),
                    child: AppSvg(path: Assets.icons.maintenance),
                  ),
                ),
              ),

              if (ownerDetail != null) const ContactSupportSection(),
            ],
          ),
          bottomNavigationBar: AppContainer(
            height: 100,

            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          summary.nextPaymentDue ?? "N/A",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        AppText.small(
                          summary.nextPaymentLabel ?? "Next installment",
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text:
                          "Pay \$${summary.rentPaymentStatus?.paymentAmount ?? summary.remainingAmount ?? 0} now",
                      onPressed: () {},
                      width: 160,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
