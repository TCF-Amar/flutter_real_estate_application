import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class AgentInfo extends StatelessWidget {
  const AgentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Marked as Agent"),
          const SizedBox(height: 16),
          //? agent info goes here
          // ExploreAgentCard(agent: controller!.agentDetail!),
        ],
      ),
    );
  }
}
