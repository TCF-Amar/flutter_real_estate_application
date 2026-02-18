import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

/// Navigation button for onboarding screens with pulsing shadow effect
class OnboardingNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OnboardingNavigationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                spreadRadius: 8,
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                spreadRadius: 15,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_forward, color: AppColors.white),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
