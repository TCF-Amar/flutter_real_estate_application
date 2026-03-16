import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_container.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart';

class CountrySettingTile extends StatelessWidget {
  const CountrySettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final ProfileController controller = Get.find();

    return Obx(() {
      final userCountry = authController.userProfile.value?.country;
      final match = authController.countries
          .where((e) => e['name'] == userCountry)
          .toList();
      final flag = match.isNotEmpty ? match.first['flag'] ?? '' : '';
      final countryName = userCountry ?? 'Not selected';

      return AppContainer(
        onTap: () {
          Get.toNamed(
            AppRoutes.selectCountry,
            arguments: {
              'onPress': () {
                final selected = authController.selectedCountry.value;
                authController.userProfile.value = authController
                    .userProfile
                    .value
                    ?.copyWith(country: selected);
                controller.updateCountry(selected);
                Get.back();
              },
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("country".tr, fontSize: 14, fontWeight: .w500),
                  const SizedBox(height: 8),
                  AppText(
                    "text1".tr,
                    fontSize: 10,
                    color: AppColors.textTertiary,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (flag.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    AppText(flag  ),
                    const SizedBox(width: 8),
                    AppText(
                      countryName.split(" ").map((w) => w[0]).join(""),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 10),
                    Transform(
                      transform: Matrix4.translation(Vector3(0, -3, 0)),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
