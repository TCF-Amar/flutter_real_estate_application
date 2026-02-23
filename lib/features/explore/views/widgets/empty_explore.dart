import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class EmptyExplore extends StatelessWidget {
  const EmptyExplore({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.emptyExplore, height: 200, width: 200),
            const SizedBox(height: 16),
            const AppText(
              "No properties found...",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            const AppText(
              "Try changing your filters or search criteria",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: () {
                controller.refreshProperties();
              },
              text: 'Explore All Properties',
            ),
            const SizedBox(height: 12),
            AppButton(
              showShadow: false,
              isBorder: true,
              borderColor: AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              textColor: AppColors.textSecondary,
              onPressed: () {
                controller.resetFilters();
              },
              text: 'Reset Filters',
            ),
          ],
        ),
      ),
    );
  }
}
