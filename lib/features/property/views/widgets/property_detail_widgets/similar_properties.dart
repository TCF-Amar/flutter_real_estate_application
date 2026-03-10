import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SimilarProperties extends StatefulWidget {
  const SimilarProperties({super.key});

  @override
  State<SimilarProperties> createState() => _SimilarPropertiesState();
}

class _SimilarPropertiesState extends State<SimilarProperties> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();

    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Similar Properties"),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingSimilar) {
              return const SizedBox(
                height: 200,

                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (controller.similarProperties.isEmpty) {
              return AppContainer(
                height: 200,
                showBorder: true,
                child: Center(
                  child: AppText(
                    "No similar properties found",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.similarProperties.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Obx(
                      () => ModernPropertyCard(
                        isSimilar: true,
                        property: controller.similarProperties[index],
                        onToggleFavorite: () {
                          controller.updateSimilarFavorite(
                            controller.similarProperties[index].id,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // ── Page-indicator dots ──────────────────────────────
          Obx(() {
            final count = controller.similarProperties.length;
            if (count == 0) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 8, right: 4),
                  height: 7,
                  width: active ? 18 : 7,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
