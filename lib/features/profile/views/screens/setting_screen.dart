// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' ;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_container.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/back_button.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: HeaderText(text: "Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Obx(() {
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
                          authController.userProfile.value = authController.userProfile.value?.copyWith(
                            country: countryName,
                          );
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
                            AppText("Country", fontSize: 14, fontWeight: .w500),
                            const SizedBox(height: 8),
                            AppText(
                              "Choose the country where you want to explore properties or make investments.",
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
                              Text(flag, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              AppText(
                                countryName
                                    .split(" ")
                                    .map((w) => w[0])
                                    .join(""),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(width: 10),
                              Transform(
                                transform: Matrix4.translation(
                                  Vector3(0, -3, 0),
                                ),
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
              }),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
