import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/initial/models/onboarding_page_data.dart';
import 'package:real_estate_app/features/initial/views/widgets/onboarding_navigation_button.dart';
import 'package:real_estate_app/features/initial/views/widgets/onboarding_page_content.dart';
import 'package:real_estate_app/features/initial/views/widgets/onboarding_page_indicator.dart';

/// A single page in the onboarding flow
class OnboardingPageItem extends StatelessWidget {
  final OnboardingPageData pageData;
  final int pageIndex;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;

  const OnboardingPageItem({
    super.key,
    required this.pageData,
    required this.pageIndex,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        _buildBackgroundImage(),

        // Gradient overlay
        _buildGradientOverlay(),

        // Content
        _buildContent(),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        pageData.image,
        fit: BoxFit.fitHeight,
        alignment: pageIndex == 0 ? Alignment.centerRight : Alignment.center,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xFF1B0E40)],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      top: Get.height / 2,
      bottom: 50,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingPageIndicator(
                pageCount: totalPages,
                currentPage: currentPage,
              ),
              const SizedBox(height: 24),
              OnboardingPageContent(pageData: pageData),
              const SizedBox(height: 34),
              OnboardingNavigationButton(onPressed: onPressed),
            ],
          ),
        ),
      ),
    );
  }
}
