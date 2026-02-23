import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/explore/views/widgets/property_detail_widgets/header_section.dart';
import 'package:real_estate_app/features/explore/views/widgets/property_detail_widgets/saved_and_chips.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/back_button.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

import '../widgets/property_detail_widgets/index.dart';

class PropertyDetailsScreen extends GetView<PropertyDetailsController> {
  final int id;
  const PropertyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
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
              title: const HeaderText(
                text: "Property Details",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
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
              ],
              flexibleSpace: HeaderSection(property: property),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? media images
                    MediaImages(media: property.media!),
                    const SizedBox(height: 16),
                    SavedAndChips(property: property),
                    const SizedBox(height: 16),

                    const SizedBox(height: 1000), // Space for bottom bar
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
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText("Contact Seller"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText("Book a Visit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
