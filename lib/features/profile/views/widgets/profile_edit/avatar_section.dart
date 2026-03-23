import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AvatarSection extends StatelessWidget {
  final UserModel user;
  final ProfileController controller;
  const AvatarSection({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: AppImage(
                    path: user.profileImage,
                    errorImagePath: Assets.icons.person,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            left: Get.width / 6,
            bottom: 0,
            child: GestureDetector(
              onTap: () => controller.selectImage(context),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: AppSvg(path: Assets.icons.gallery),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
