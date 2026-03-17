import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class EmptyExplore extends StatelessWidget {
  final String? error;
  final String? type;
  final VoidCallback refreshFun;
  final VoidCallback resetFun;

  const EmptyExplore({
    super.key,
    this.error,
    this.type,
    required this.refreshFun,
    required this.resetFun,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.emptyExplore, height: 200, width: 200),
            const SizedBox(height: 16),
            if (error != null) ...[
              AppText("$error", fontSize: 16, fontWeight: FontWeight.bold),
              const SizedBox(height: 16),
            ],
            AppText(
              "No ${type ?? "Data"} found...",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            const AppText(
              "Try changing your filters or search criteria",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(onPressed: refreshFun, text: 'Explore All Properties'),
            const SizedBox(height: 12),
            AppButton(
              showShadow: false,
              isBorder: true,
              borderColor: AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              textColor: AppColors.textSecondary,
              onPressed: resetFun,
              text: 'Reset Filters',
            ),
          ],
        ),
      ),
    );
  }
}
