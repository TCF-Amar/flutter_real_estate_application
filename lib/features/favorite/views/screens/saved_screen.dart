import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/favorite/views/widgets/favorite_card.dart';
import 'package:real_estate_app/features/main/controllers/main_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: HeaderText(text: "Favorites"),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.savedProperties.isEmpty) {
                  return _EmptyState(
                    onRefresh: () async {
                      await controller.refreshSavedProperties();
                    },
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await controller.refreshSavedProperties();
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    children: [
                      AppText(
                        "Saved Properties(${controller.savedProperties.length})",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 10),
                      ...controller.savedProperties.map(
                        (property) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FavoriteCard(property: property),
                        ),
                      ),
                      const AppText(
                        "Saved Agents",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 10),

                      // ...controller.savedAgents.map(
                      //   (agent) => Padding(
                      //     padding: const EdgeInsets.only(bottom: 12),
                      //     child: FavoriteCard(property: agent),
                      //   ),
                      // ),
                      const AppText(
                        "Saved Developers",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 10),

                      // ...controller.savedDevelopers.map(
                      //   (developer) => Padding(
                      //     padding: const EdgeInsets.only(bottom: 12),
                      //     child: FavoriteCard(property: developer),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvg(
            path: Assets.icons.heartSelected,
            height: 70,
            // width: 100,
            color: AppColors.primary,
          ),
          const SizedBox(height: 40),
          const AppText(
            "No Favorites Yet...",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          const AppText(
            "Start exploring properties and tap the heart\n icon to add your favorites here.",
            textAlign: TextAlign.center,
            fontSize: 13,
            color: AppColors.grey,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AppButton(
              text: "Explore Properties",
              onPressed: () {
                mainController.currentIndex(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
