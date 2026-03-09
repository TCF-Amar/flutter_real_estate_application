import 'package:flutter/material.dart' hide Title;
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/property/views/widgets/property_detail_widgets/index.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyDetailsScreen extends GetView<PropertyDetailsController> {
  // final int id;
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final property = controller.propertyDetail;
        if (property == null) {
          return const Center(child: AppText("Property details not found."));
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
      bottomNavigationBar: Container(
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
                        path: authController.userProfile.value?.profileImage,
                        radius: BorderRadius.circular(50),
                        errorIcon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          authController
                                  .user
                                  .value!
                                  .fullName
                                  ?.capitalizeFirst ??
                              "User",
                          fontWeight: .bold,
                        ),
                        AppText(
                          authController.userProfile.value?.country ?? "N/A",
                          fontSize: 10,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(text: "Book Visit", onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
