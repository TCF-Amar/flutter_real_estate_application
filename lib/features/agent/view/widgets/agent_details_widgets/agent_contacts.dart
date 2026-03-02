import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class AgentContacts extends StatelessWidget {
  const AgentContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentDetailsController>();
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.agentDetails?.phone != null &&
                controller.agentDetails!.phone.isNotEmpty) ...[
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: AppText(controller.agentDetails!.phone),
                subtitle: const Text("Phone number"),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: const Text("N/A"),
                subtitle: const Text("Phone number"),
              ),
            ],
            if (controller.agentDetails?.email != null &&
                controller.agentDetails!.email.isNotEmpty) ...[
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.primary),
                title: AppText(controller.agentDetails!.email),
                subtitle: const Text("Email"),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.primary),
                title: const Text("N/A"),
                subtitle: const Text("Email"),
              ),
              // location
            ],
            if (controller.agentDetails?.location != null &&
                controller.agentDetails!.location!.isNotEmpty) ...[
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                title: AppText(controller.agentDetails!.location.toString()),
                subtitle: const Text("Location"),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                title: const Text("N/A"),
                subtitle: const Text("Location"),
              ),
            ],

          ],
        ),
      ),
    );
  }
}
