import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/date_time_utils.dart';
import 'package:real_estate_app/features/shared/models/reviews_summary_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

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
                        SvgPicture.asset(Assets.icons.star),
                        AppText(
                          " ${reviewsSummary.averageRating ?? 0}  (out of 5)",
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
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
      // margin: const EdgeInsets.only(top: 16),
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
                      child: SvgPicture.asset(
                        Assets.icons.star,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 6),
              AppText(
                "${review.rating}/5",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          // const SizedBox(height: 12),
          AppText(
            "\"${review.comment}\"",
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                // backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    (review.reviewerImage != null &&
                        review.reviewerImage!.isNotEmpty)
                    ? NetworkImage(review.reviewerImage!)
                    : null,
                child:
                    (review.reviewerImage == null ||
                        review.reviewerImage!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
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
            Divider(color: AppColors.textSecondary.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}
