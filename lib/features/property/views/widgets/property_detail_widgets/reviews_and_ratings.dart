import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';

class ReviewsAndRatings extends StatelessWidget {
  const ReviewsAndRatings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Reviews "),

          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      AppText(
                        "${controller.reviewsSummary?.totalReviews ?? 0} Reviews",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          AppSvg(path: Assets.icons.star),
                          AppText(
                            " ${controller.reviewsSummary?.averageRating ?? 0}  (out of 5)",
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (controller.reviews.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: AppText(
                          "No reviews yet",
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index) {
                      final review = controller.reviews[index];
                      return ReviewCard(
                        review: review,
                        index: index,
                        length: controller.reviews.length,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          if (controller.hasMore)
            LoadMoreButton(
              isLoading: controller.isLoadingMoreReviews,
              onPressed: controller.loadMoreReviews,
            ),

          Container(
            margin: const EdgeInsets.only(top: 16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(text: "Leave a Review"),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Rating & Review",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => Row(
                          children: List.generate(5, (index) {
                            final filled = index < controller.rating;
                            return GestureDetector(
                              onTap: () {
                                controller.setRating(index + 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3),
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
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        // controller: controller.commentController,
                        // hintText: "Write your review",
                        maxLines: 5,
                        controller: controller.commentController,

                        decoration: InputDecoration(
                          hintText: "Write Something",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: "Send",
                        isLoading: controller.isLoadingReviews,

                        onPressed: () {
                          controller.addReview(controller.propertyId.value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
