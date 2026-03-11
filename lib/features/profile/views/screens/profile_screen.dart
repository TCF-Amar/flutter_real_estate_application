import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/profile/views/widgets/profile_header_section.dart';
import 'package:real_estate_app/features/profile/views/widgets/profile_option.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.find<AuthController>();
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshProfile();
      },
      child: Scaffold(
        body: Obx(() {
          if (controller.refreshing) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.user.value == null) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    controller.error?.message ?? 'Something went wrong',
                    overflow: TextOverflow.clip,
                    color: AppColors.textTertiary,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: "Retry",
                    onPressed: controller.refreshProfile,
                  ),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 230,

                title: HeaderText(
                  text: "Profile",
                  color: AppColors.white,
                  // shadow: true,
                  // shadowColor: AppColors.grey,
                ),
                centerTitle: true,
                // pinned: true,
                surfaceTintColor: AppColors.white,
                backgroundColor: AppColors.white,
                flexibleSpace: ProfileHeaderSection(),
              ),

              SliverToBoxAdapter(child: ProfileOption()),
            ],
          );
        }),
      ),
    );
  }
}
