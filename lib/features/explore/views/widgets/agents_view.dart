import 'package:flutter/material.dart';
import 'package:real_estate_app/features/explore/controllers/agent_controller.dart';
import 'package:real_estate_app/features/shared/widgets/agent_card.dart';
import 'package:get/get.dart';

class AgentsView extends StatelessWidget {
  const AgentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentController>();
    // Dummy Data
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.agents.isEmpty) {
        return const Center(child: Text("No agents found"));
      }
      return ListView.separated(
        itemCount: controller.agents.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 10),

        itemBuilder: (context, index) {
          final agent = controller.agents[index];
          return ExploreAgentCard(agent: agent);
        },
      );
    });
  }
}
