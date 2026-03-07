import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_details_widgets/index.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentDetailScreen extends GetView<AgentDetailsController> {
  const AgentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final agent = controller.agentDetails;

        if (agent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.grey.withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Get.back(),
              ),
              expandedHeight: 370,
              title: const HeaderText(
                text: "Agent Details",
                color: Colors.white,
                shadow: true,
                shadowColor: Colors.black45,
              ),
              centerTitle: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: HeaderSection(agent: agent),
            ),

            // Name + role + agency
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Stats: rating, experience, properties
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _statColumn(
                        icon: Assets.icons.star,
                        value:
                            "${agent.rating.toStringAsFixed(1)} (${agent.reviewCount} reviews)",
                        label: 'Rating',
                      ),
                    ),
                    Expanded(
                      child: _statColumn(
                        icon: Assets.icons.bag,
                        value: '${agent.experience ?? 0} Years',
                        label: 'Experience',
                      ),
                    ),
                    Expanded(
                      child: _statColumn(
                        icon: Assets.icons.home_2,
                        value: '${agent.propertiesCount} Properties',
                        label: 'Listing',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            AgentInfo(),

            AgentContacts(),

            Graph(graphData: agent.graphData),

            AgentAbout(agent: agent),

            ListedProperty(),

            AgentReviews(),

            ADContactForm(),

            const SliverToBoxAdapter(child: SizedBox(height: 300)),
          ],
        );
      }),
    );
  }

  Widget _statColumn({
    required String icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSvg(path: icon, width: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
