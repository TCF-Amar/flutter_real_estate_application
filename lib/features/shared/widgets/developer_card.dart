import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class ExploreDeveloperCard extends StatelessWidget {
  final String logo;
  final String name;
  final int projectCount;
  final String experience;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;

  const ExploreDeveloperCard({
    super.key,
    required this.logo,
    required this.name,
    required this.projectCount,
    required this.experience,
    this.onTap,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.1),
                ),
              ),
              child: Image.network(
                logo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.business_rounded,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          name,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    "Mumbai, Maharashtra", // Placeholder or pass location
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatItem(
                        icon: Icons.apartment_rounded,
                        label: "$projectCount Projects",
                      ),
                      const SizedBox(width: 16),
                      _StatItem(
                        icon: Icons.history_rounded,
                        label: "$experience Years",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onViewDetails,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  "View",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 4),
        AppText(
          label,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
