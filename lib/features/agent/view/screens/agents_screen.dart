import 'package:flutter/material.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/shared/widgets/loaders/agent_card_skeleton.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_filter.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:get/get.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentController>();

    return Column(
      children: [
        // ── Search + filter bar (always visible) ──────
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppText('Explore Agents', color: Colors.grey),
          ),
        ),

        // ── Content area ──────────────────────────────
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refreshAgents,
            child: Obx(() {
              if (controller.isLoadingList) {
                return const AgentListSkeleton(count: 5);
              }

              if (controller.agents.isEmpty) {
                return const Center(child: Text('No agents found'));
              }

              return ListView.separated(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(bottom: 24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    controller.agents.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == controller.agents.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ExploreAgentCard(
                    agent: controller.agents[index],
                    onTap: () => Get.toNamed(
                      AppRoutes.agentDetails,
                      arguments: {'id': controller.agents[index].id},
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
