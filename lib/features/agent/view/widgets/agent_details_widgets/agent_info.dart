import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentInfo extends StatelessWidget {
  const AgentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentDetailsController>();
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(child: AppText("Agent License: ", fontSize: 12)),
                SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    controller.agentDetails?.licenseNumber ?? "N/A",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: AppText(
                    "Tax Number: ",
                    // fontWeight: FontWeight.w100,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    controller.agentDetails?.taxNumber ?? "N/A",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AppText("Specialities: ", fontSize: 12)),
                SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    controller.agentDetails?.specialities ?? "N/A",
                    // overflow: TextOverflow.clip,
                    fontSize: 12,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
