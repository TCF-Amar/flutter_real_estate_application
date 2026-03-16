import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_details_widgets/agent_ael.dart';
import 'package:real_estate_app/features/agent/view/widgets/agent_details_widgets/index.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentDetailScreen extends GetView<AgentDetailsController> {
  const AgentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final agent = controller.agentDetails;
        final err = controller.error;
        if (err != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: .center,

                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  AppText(
                    err.message,
                    overflow: .visible,
                    textAlign: .center,
                    color: Colors.red,
                    fontSize: 24,
                  ),
                  SizedBox(height: 20),

                  AppButton(text: "Back", onPressed: () => Get.back()),
                ],
              ),
            ),
          );
        }

        if (agent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: AppBackButton(),
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
            AgentAel(),

            AgentInfo(),

            AgentContacts(),

            Graph(graphData: agent.graphData),

            AgentAbout(agent: agent),

            ListedProperty(),

            AgentReviews(),

            ADContactForm(),
          ],
        );
      }),
    );
  }
}
