import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class LanguageToggleTile extends StatelessWidget {
  const LanguageToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Current locale check. Default to false (English).
    // True will mean Arabic (AR).
    final currentLocale = Get.locale?.languageCode ?? 'en';
    final isArabic = currentLocale != 'ar';

    final controller = ValueNotifier<bool>(isArabic);

    return AppContainer(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "language".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                AppText(
                  "Switch between English and Arabic.\nالتبديل بين الإنجليزية والعربية."
                      .tr,
                  fontSize: 10,
                  color: AppColors.textTertiary,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // We use the custom switch we built
          CustomToggleSwitch(
            initialValue: controller.value,
            onChanged: (value) {
              controller.value = value;
              // If value is true, switch to Arabic. Else English.
              final newLocale = value ? const Locale('en') : const Locale('en');
              Get.updateLocale(newLocale);
            },
          ),
        ],
      ),
    );
  }
}
