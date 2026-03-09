import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/profile/views/widgets/log_out_confirm.dart';
import 'package:real_estate_app/features/profile/views/widgets/profile_tile.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class ProfileOptionItem {
  final String icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback action;

  ProfileOptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.action,
  });
}

class ProfileOption extends StatelessWidget {
  const ProfileOption({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final user = controller.user.value!;

    final List<ProfileOptionItem> items = [
      ProfileOptionItem(
        icon: Assets.icons.icon1,
        label: "Edit Profile",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {
          Get.toNamed(AppRoutes.editProfile, arguments: user);
        },
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon2,
        label: "Support",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {
          Get.toNamed(AppRoutes.support);
        },
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon3,
        label: "Property Maintenance",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon4,
        label: "Transactions",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon5,
        label: "Setting",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon6,
        label: "Term and conditions",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon7,
        label: "Privacy Policy",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon8,
        label: "Change password",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.icon9,
        label: "Delete account",
        color: AppColors.primary,
        textColor: AppColors.textPrimary,
        action: () {},
      ),
      ProfileOptionItem(
        icon: Assets.icons.exit,
        label: "Log out",
        color: AppColors.error,
        textColor: AppColors.error,
        action: () async {
          final confirm = await showLogoutDialog(context);
          if (confirm == true) {
            // Get.offAllNamed(AppRoutes.signin);
            AppSnackbar.success("");
          }
        },
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ProfileTile(
              icon: item.icon,
              label: item.label,
              color: item.color,
              textColor: item.textColor,
              action: item.action,
            ),
          );
        },
      ),
    );
  }
}
