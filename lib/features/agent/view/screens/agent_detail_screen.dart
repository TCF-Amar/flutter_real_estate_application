import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_details_widgets/agent_contacts.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_details_widgets/agent_info.dart';

import '../../../shared/widgets/index.dart';

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
                icon: const Icon(Icons.arrow_back),
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
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Cover Image
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 170,
                      child: AppImage(path: agent.image, fit: BoxFit.cover),
                    ),

                    // Dark overlay for readability
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 170,
                      child: Container(color: Colors.black.withValues(alpha: 0.18)),
                    ),

                    // Circular avatar overlapping content
                    Positioned(
                      bottom: 100,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 72,
                          backgroundImage:
                              agent.image != null && agent.image!.isNotEmpty
                              ? NetworkImage(agent.image!)
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              agent.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              agent.roleType,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if ((agent.agencyName).isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'At ${agent.agencyName}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        value: '${agent.experience ?? 0}',
                        label: 'Years',
                      ),
                    ),
                    Expanded(
                      child: _statColumn(
                        icon: Assets.icons.home_2,
                        value: '${agent.propertiesCount }',
                        label: 'Properties',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Description
            if ((agent.description ?? '').isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    agent.description ?? '',
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            AgentInfo(),

            AgentContacts(),

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
