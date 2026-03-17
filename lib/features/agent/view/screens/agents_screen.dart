import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_filter.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:get/get.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentController>();

    return RefreshIndicator(
      onRefresh: controller.refreshAgents,
      child: CustomScrollView(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Floating Header
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  ExploreSearchFilter(
                    hintText: 'Search Agents',
                    onChanged: (val) {
                      controller.searchQuery.value = val;
                    },
                    controller: controller.searchController,
                    handleSearch: () => controller.handleSearch(),
                    onFilterTap: () => AgentFilters.showFilters(context),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.large(
                      'Explore Agents',
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Content area
          Obx(() {
            if (controller.isLoadingList) {
              return const SliverFillRemaining(
                child: AgentListSkeleton(count: 5),
              );
            }

            if (controller.agents.isEmpty) {
              return SliverFillRemaining(
                child: Center(child: AppText('No agents found'.tr)),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == controller.agents.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Column(
                      children: [
                        ExploreAgentCard(
                          onFavoriteTap: () {
                            Get.find<FavoriteController>().toggleFavoriteAgent(
                              controller.agents[index],
                            );
                          },
                          agent: controller.agents[index],
                          onTap: () => Get.toNamed(
                            AppRoutes.agentDetails,
                            arguments: {'id': controller.agents[index].id},
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                  childCount:
                      controller.agents.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
