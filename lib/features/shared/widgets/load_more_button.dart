import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class LoadMoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  const LoadMoreButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 70),
      child: AppButton(
        text: "Load More",
        textColor: AppColors.textSecondary,
        isLoading: isLoading,
        isBorder: true,
        showShadow: false,
        backgroundColor: AppColors.white,
        fontWeight: .w400,
        padding: EdgeInsets.symmetric(vertical: 12),
        onPressed: onPressed,
        borderColor: AppColors.textSecondary.withValues(alpha: 0.2),
      ),
    );
  }
}
