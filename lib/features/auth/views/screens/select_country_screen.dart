import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_button.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class SelectCountryScreen extends GetView<AuthController> {
  const SelectCountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header — back button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    AppText(
                      "Select Country",
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),

                    const SizedBox(height: 16),

                    AppText(
                      "Select the Country You're Interested in?",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.background,
                    ),

                    const SizedBox(height: 8),

                    AppText(
                      "Choose the country where you want to explore properties or make investments.",
                      fontSize: 14,
                      color: AppColors.background.withValues(alpha: 0.6),
                      height: 1.5,
                      overflow: TextOverflow.clip,
                    ),

                    const SizedBox(height: 32),

                    // Country list — each tile is individually reactive
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.countries.length,
                        itemBuilder: (context, index) {
                          final country = controller.countries[index];

                          return Obx(() {
                            final isSelected =
                                controller.selectedCountry.value ==
                                country['name'];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () =>
                                    controller.selectCountry(country['name']!),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withValues(
                                            alpha: 0.1,
                                          )
                                        : AppColors.background.withValues(
                                            alpha: 0.03,
                                          ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Flag
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.background
                                                .withValues(alpha: 0.1),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            country['flag']!,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      // Country Name
                                      Expanded(
                                        child: AppText(
                                          country['name']!,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.background,
                                        ),
                                      ),

                                      // Check icon
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: AppButton(
                text: "Continue",
                onPressed: controller.handleContinue,
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
