import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/visit_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitDetailsReviewSection extends GetView<VisitDetailsController> {
  const VisitDetailsReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Leave a Review",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    "Rating & Review",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: List.generate(5, (index) {
                        final filled = index < controller.rating;
                        return GestureDetector(
                          onTap: () => controller.setRating(index + 1),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ColorFiltered(
                              colorFilter: filled
                                  ? const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.dst,
                                    )
                                  : const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                              child: AppSvg(
                                path: Assets.icons.star,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.commentController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Write something",
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => AppText(
                        "${controller.commentLength}/10000",
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => AppButton(
                      text: "Send",
                      isLoading: controller.isSubmittingReview,
                      onPressed: controller.addReview,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
