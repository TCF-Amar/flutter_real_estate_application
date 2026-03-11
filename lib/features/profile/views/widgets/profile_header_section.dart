// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';

import 'package:real_estate_app/features/shared/widgets/index.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final log = Logger();
    final auth = Get.find<ProfileController>();
    log.d(auth.user.toJson());

    return FlexibleSpaceBar(
      background: Obx(() {
        if (auth.user.value == null) {
          return AppContainer(child: Center(child: AppText("Server Error")));
        }
        return Stack(
          children: [
            // SizedBox(width: double.infinity, height: 250),
            Positioned(
              top: 0,
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                height: 100,

                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  // image: DecorationImage(
                  //   image: auth.userProfile.value?.profileImage != null
                  //       ? NetworkImage(auth.userProfile.value!.profileImage!)
                  //       : AssetImage(Assets.images.topImage),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                // color: Colors.blue,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                width: double.infinity,
                color: AppColors.background.withValues(alpha: 0.7),
              ),
            ),

            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.white,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: AppImage(
                      path: auth.user.value?.profileImage ?? "",
                      errorImagePath: Assets.icons.person,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: AppText(
                  auth.user.value!.fullName!.capitalizeFirst ?? "",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
