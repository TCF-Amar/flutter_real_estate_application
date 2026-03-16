import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/models/contact_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentInfo extends StatelessWidget {
  final ContactModel contact;

  const AgentInfo({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Marked as Agent"),
          const SizedBox(height: 16),

          FutureBuilder(
            future: controller.fetchAgentById(contact.agentId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: AppText(snapshot.error.toString()));
              }
              if (!snapshot.hasData) {
                return const Center(child: AppText("No agent found"));
              }
              final agent = snapshot.data;
              return ExploreAgentCard(
                agent: agent!,
                onTap: () => Get.toNamed(
                  AppRoutes.agentDetails,
                  arguments: {'id': agent.id},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
