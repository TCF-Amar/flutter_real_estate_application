import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
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
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                Assets.icons.phone,
                width: 20,
                colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),

                // height: 24,
              ),
              title: AppText(
                controller.agentDetails?.phone ?? "N/A",
                fontWeight: FontWeight.w500,
              ),
              subtitle: const Text("Phone number"),
            ),

            ListTile(
              leading: SvgPicture.asset(
                Assets.icons.mail,
                width: 20,
                colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),

                // height: 24,
              ),
              title: AppText(
                controller.agentDetails?.email ?? "N/A",
                fontWeight: FontWeight.w500,
              ),
              subtitle: const Text("Email"),
            ),

            ListTile(
              leading: SvgPicture.asset(
                Assets.icons.location,
                width: 20,
                // height: 24,
                colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
              ),
              title: AppText(
                controller.agentDetails?.location ?? "N/A",
                fontWeight: FontWeight.w500,
              ),
              subtitle: const Text("Location"),
            ),
          ],
        ),
      ),
    );
  }
}
