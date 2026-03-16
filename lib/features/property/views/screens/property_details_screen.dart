import 'package:flutter/material.dart' hide Title;
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/views/widgets/property_detail_widgets/index.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyDetailsScreen extends GetView<PropertyDetailsController> {
  // final int id;
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final property = controller.propertyDetail;
        final err = controller.error;

        if (err != null) {
          return AppErrorState(message: err.message, onRetry: controller.retry);
        }

        if (property == null) {
          return const AppEmptyState(
            title: "Property details not found",
            message: "We couldn't retrieve the details for this property.",
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              expandedHeight: 450,
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: AppBackButton(),
              ),
              title: HeaderText(
                text: "Property Details",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                shadow: true,
                shadowColor: Colors.black.withValues(alpha: 0.5),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.black.withValues(alpha: 0.4),
                  ),
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
              ],
              flexibleSpace: HeaderSection(),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? media images
                    MediaImages(media: property.media!),

                    //? saved and chips
                    SavedAndChips(),

                    // title
                    Title(property: property),

                    //! price and description
                    PriceAndDescription(property: property),

                    //! Property overview
                    Overview(property: property),

                    //! project overview
                    if (property.isNotCompleted)
                      ProjectOverview(overview: property.projectOverview!),

                    //! latest update
                    if (property.isNotCompleted)
                      LatestUpdate(update: property.latestUpdate!),

                    //! map preview
                    MapPreview(),

                    //! Address
                    Address(address: property.address!),

                    //! Amenities & Features
                    AmenitiesFeatures(amenities: property.amenities!),

                    //! Configurations & Unit Plans
                    ConfigurationsUnitPlans(),

                    //! Videos
                    VideoPreview(videos: property.media!.videos),

                    //! Virtual Tour
                    const VirtualTour(),

                    property.isProject
                        ? DeveloperInfo()
                        : AgentInfo(contact: property.contact!),

                    //! Reviews & Ratings
                    ReviewsAndRatings(),

                    //! Similar Properties
                    SimilarProperties(),

                    //! Location Map
                    ContactMessage(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final property = controller.propertyDetail;
        if (property == null || controller.isLoading) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: AppImage(
                          path: "${property.contact?.profileImage}",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(50),
                          errorIcon: Icons.person,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              property.contact?.name?.capitalizeFirst ??
                                  'Agent',
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppText(
                              "${property.address?.city ?? ''} ${property.address?.country ?? ''}",
                              fontSize: 10,
                              color: AppColors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    text: "Book Visit",
                    onPressed: () {
                      Get.toNamed(AppRoutes.bookVisit, arguments: property);
                    },
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
