import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ProfileEdit extends StatelessWidget {
  final UserModel user;
  const ProfileEdit({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarSection(user: user, controller: controller),
            const SizedBox(height: 24),
            _NameField(controller: controller),
            const SizedBox(height: 24),
            _EmailField(user: user, controller: controller),
            const SizedBox(height: 24),
            _PhoneField(user: user, controller: controller),
            const SizedBox(height: 24),
            _SaveButton(controller: controller),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBackButton(),
      ),
      title: HeaderText(text: 'Edit Profile'),
      centerTitle: true,
    );
  }
}

// ─── Avatar ──────────────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final UserModel user;
  final ProfileController controller;
  const _AvatarSection({required this.user, required this.controller});

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

// ─── Name Field ───────────────────────────────────────────────────────────────

class _NameField extends StatelessWidget {
  final ProfileController controller;
  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Full Name'),
        const SizedBox(height: 10),
        AppTextFormField(
          hintText: 'Enter full name',
          controller: controller.nameController,
          borderSideType: BorderSideType.bottom,
          fontSize: 14,
          borderRadius: BorderRadius.zero,
          keyboardType: TextInputType.name,
          borderColor: AppColors.grey.withValues(alpha: 0.2),
          prefixIcon: AppSvg(path: Assets.icons.person, width: 12, height: 12),
        ),
      ],
    );
  }
}

// ─── Email Field ──────────────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  final UserModel user;
  final ProfileController controller;
  const _EmailField({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Email'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(
                () => AppTextFormField(
                  hintText: 'Enter email',
                  fontSize: 14,
                  controller: controller.emailController,
                  borderSideType: BorderSideType.bottom,
                  borderColor: AppColors.grey.withValues(alpha: 0.2),
                  keyboardType: TextInputType.emailAddress,
                  borderRadius: BorderRadius.zero,

                  prefixIcon: AppSvg(
                    path: Assets.icons.mail,
                    width: 12,
                    height: 12,
                  ),
                  suffixIcon: controller.isEmailVerified
                      ? Icon(Icons.verified, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => AppButton(
                  text: controller.isEmailVerified ? 'Verified' : 'Verify',
                  onPressed: controller.isEmailVerified
                      ? () {}
                      : () => controller.verifyField('email'),
                  fontSize: 14,
                  backgroundColor: controller.isEmailVerified
                      ? AppColors.primary
                      : Colors.transparent,
                  showShadow: controller.isEmailVerified,
                  isLoading: controller.isVerifyingEmail,
                  isBorder: !controller.isEmailVerified,
                  borderColor: AppColors.primary,
                  textColor: controller.isEmailVerified
                      ? null
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Phone Field ──────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final UserModel user;
  final ProfileController controller;
  const _PhoneField({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Phone Number'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Obx(
                () => AppTextFormField(
                  hintText: 'Enter phone number',
                  fontSize: 14,
                  controller: controller.phoneController,
                  borderSideType: BorderSideType.bottom,
                  borderColor: AppColors.grey.withValues(alpha: 0.2),
                  keyboardType: TextInputType.phone,
                  borderRadius: BorderRadius.zero,

                  prefixIcon: AppSvg(
                    path: Assets.icons.phone,
                    width: 12,
                    height: 12,
                  ),
                  suffixIcon: controller.isPhoneVerified
                      ? Icon(Icons.verified, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => AppButton(
                  text: controller.isPhoneVerified ? 'Verified' : 'Verify',
                  fontSize: 14,
                  backgroundColor: controller.isPhoneVerified
                      ? AppColors.primary
                      : Colors.transparent,
                  onPressed: controller.isPhoneVerified
                      ? () {}
                      : () {
                          controller.verifyField('phone');
                        },
                  showShadow: controller.isPhoneVerified,
                  isLoading: controller.isVerifyingPhone,
                  isBorder: !controller.isPhoneVerified,
                  borderColor: AppColors.primary,
                  textColor: controller.isPhoneVerified
                      ? null
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Save Button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final ProfileController controller;
  const _SaveButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          AppButton(
            text: 'Save',
            isLoading: controller.isUpdating,
            onPressed: controller.updateProfile,
          ),
        ],
      ),
    );
  }
}
