import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/features/shared/widgets/load_more_button.dart';

class AgentReviews extends StatelessWidget {
  const AgentReviews({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentDetailsController>();
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: "Reviews"),

            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        AppText(
                          "${controller.reviewsSummary?.totalReviews ?? 0} Reviews",
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 30),
                        AppSvg(path: Assets.icons.star, width: 20, height: 20),
                        AppText(
                          "${controller.reviewsSummary?.averageRating ?? 0}.rating}",
                          color: AppColors.textSecondary,
                        ),
                        AppText(" (Out of 5)", color: AppColors.textSecondary),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 20),
                  Obx(() {
                    if (controller.reviews.isEmpty) {
                      return Center(
                        child: AppText(
                          "No reviews yet",
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        final review = controller.reviews[index];
                        return ReviewCard(
                          review: review,
                          index: index,
                          length: controller.reviews.length,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Obx(() {
              if (controller.reviews.isEmpty) return const SizedBox();
              if (controller.hasMore == false) return const SizedBox();
              return LoadMoreButton(
                isLoading: controller.isLoadingMoreReviews,
                onPressed: controller.loadMoreReviews,
              );
              // Container(
              //   margin: const EdgeInsets.symmetric(
              //     vertical: 16,
              //     horizontal: 100,
              //   ),
              //   child: AppButton(
              //     padding: const EdgeInsets.symmetric(vertical: 10),
              //     borderRadius: 10,
              //     backgroundColor: AppColors.white,
              //     textColor: AppColors.primary,
              //     borderColor: AppColors.primary,
              //     showShadow: false,
              //     isBorder: true,
              //     text: controller.isLoadingMoreReviews
              //         ? "Loading..."
              //         : "Load More",
              //     onPressed: controller.isLoadingMoreReviews
              //         ? null
              //         : controller.loadMoreReviews,
              //   ),
              // );
            }),
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          text: "Send",

                          // isLoading: controller.isLoadingReviews,
                          onPressed: () {
                            controller.addReview(controller.agentDetails!.id);
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
      ),
    );
  }
}
