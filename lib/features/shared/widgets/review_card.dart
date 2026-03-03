import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/date_time_utils.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

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
                isProfileImage: true,
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
