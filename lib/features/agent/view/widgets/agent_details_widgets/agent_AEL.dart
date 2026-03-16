// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentAel extends StatelessWidget {
  const AgentAel({super.key});

  @override
  Widget build(BuildContext context) {
    final agent = Get.find<AgentDetailsController>().agentDetails!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
              AppText(
                value,
                fontWeight: FontWeight.bold,
                fontSize: 14,

                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              AppText(
                label,
                color: Colors.grey,
                fontSize: 11,
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
