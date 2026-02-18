import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/initial/models/onboarding_page_data.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

/// Widget that displays the text content of an onboarding page
class OnboardingPageContent extends StatelessWidget {
  final OnboardingPageData pageData;

  const OnboardingPageContent({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: AppText(
            pageData.title,
            fontSize: 34,
            overflow: TextOverflow.clip,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: Get.width * 0.8,
          child: AppText(
            pageData.subtitle,
            fontSize: 19,
            maxLines: 2,
            overflow: TextOverflow.clip,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
