import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
// import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
// import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/favorite/views/widgets/favorite_card.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchSavedProperties();
    // fnail List<FavoriteProperty> savedProperties =
    //     controller.savedData.data.property;
    final savedProperties = controller.savedProperties;
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (savedProperties.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 72,
                  color: AppColors.grey.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const AppText(
                  "No saved properties yet",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                const AppText(
                  "Properties you favorite will appear here",
                  fontSize: 13,
                  color: AppColors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: AppButton(
                    // onPressed: () => Get.toNamed(AppRoutes.home),
                    text: "Refresh",
                    onPressed: controller.fetchSavedProperties,

                    // color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: HeaderText(text: "Favorites"),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.refreshSavedProperties,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: savedProperties.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return FavoriteCard(property: savedProperties[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
