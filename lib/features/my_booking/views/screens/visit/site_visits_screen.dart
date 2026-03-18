import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_card.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/features/shared/widgets/loaders/site_visit_card_skeleton.dart';

class SiteVisitsTab extends GetView<MyBookingController> {
  const SiteVisitsTab({super.key});

  Widget buildList(List<VisitResponseData> visits) {
    return RefreshIndicator(
      onRefresh: controller.getVisitList,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !controller.visitLoading.value &&
              !controller.visitLoadingMore.value) {
            controller.loadMoreVisits();
          }
          return false;
        },
        child: Obx(() {
          if (controller.visitLoading.value && controller.visitList.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (visits.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 100),
                AppEmptyState(
                  title: "No Visits Found",
                  message: "You haven't booked any site visits yet.",
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: AppButton(
                    text: "Refresh",
                    onPressed: controller.getVisitList,
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount:
                visits.length + (controller.visitLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < visits.length) {
                return VisitCard(visit: visits[index]);
              }

              return const VisitCardSkeleton();
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = ["Pending", "Canceled", "Completed"];

      /// Initial Loading
      if (controller.visitLoading.value && controller.visitList.isEmpty) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (_, __) => const VisitCardSkeleton(),
        );
      }

      /// Empty State
      if (controller.visitList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppEmptyState(
                title: "No Visits Found",
                message: "You haven't booked any site visits yet.",
              ),
              const SizedBox(height: 20),
              AppButton(
                text: "Refresh",
                width: 120,
                onPressed: controller.getVisitList,
              ),
            ],
          ),
        );
      }

      return DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary,
                        ),
                        tabs: tabs.map((e) => Tab(text: e)).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              buildList(controller.pendingVisitList),
              buildList(controller.cancelledVisitList),
              buildList(controller.completedVisitList),
            ],
          ),
        ),
      );
    });
  }
}
