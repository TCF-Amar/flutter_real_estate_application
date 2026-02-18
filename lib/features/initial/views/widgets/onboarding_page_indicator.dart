import 'package:flutter/material.dart';

/// Widget that displays page indicators for the onboarding flow
class OnboardingPageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const OnboardingPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == index ? 34 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentPage == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
