import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/date_time_utils.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/models/reviews_summary_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';


class ReviewsAndRatings extends StatelessWidget {
  final ReviewsSummaryModel reviewsSummary;
  final List<ReviewModel> reviews;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const ReviewsAndRatings({
    super.key,
    required this.reviewsSummary,
    required this.reviews,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

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
            child: Column(
              children: [
                Row(
                  children: [
                    AppText(
                      "${reviewsSummary.totalReviews} Reviews",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        AppSvg(path: Assets.icons.star),
                        AppText(
                          " ${reviewsSummary.averageRating ?? 0}  (out of 5)",
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
                if (reviews.isEmpty)
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
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ReviewCard(
                      review: review,
                      index: index,
                      length: reviews.length,
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Load More button — visible only when more pages exist ──────
          if (hasMore)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              child: AppButton(
                borderRadius: 10,
                backgroundColor: AppColors.white,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                showShadow: false,
                isBorder: true,
                text: isLoadingMore ? "Loading..." : "Load More",
                onPressed: isLoadingMore ? null : onLoadMore,
              ),
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

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final int index;
  final int length;
  const ReviewCard({
    super.key,
    required this.review,
    required this.index,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final filled = index < review.rating;
                  return Padding(
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
                        width: 16,
                        height: 16,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          if (review.comment.isNotEmpty)
            AppText(
              "\"${review.comment}\"",
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppImage(
                path: review.reviewerImage,
                width: 40,
                height: 40,
                radius: BorderRadius.circular(20),
                errorIcon: Icons.person,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      review.reviewerName,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                    AppText(
                      DateTimeUtils.formatFullDate(review.createdAt),
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (index != length - 1)
            Divider(color: AppColors.textSecondary.withValues(alpha: 0.1)),
        ],
      ),
    );
  }
}
