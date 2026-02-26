import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/shared/widgets/app_image.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteProperty property;

  const FavoriteCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.propertyDetails,
        arguments: {'id': property.id},
        preventDuplicates: false,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Thumbnail ───────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
              child: AppImage(
                path: property.image,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorIcon: Icons.home_rounded,
              ),
            ),

            // ── Info ────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AppText(
                      property.title ?? "Untitled Property",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: AppText(
                            [property.city, property.state]
                                .where((e) => e != null && e.isNotEmpty)
                                .join(", "),
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (property.bhkRange != null)
                          _Tag(
                            label: property.bhkRange!,
                            icon: Icons.bed_outlined,
                          ),
                        if (property.areaRange != null)
                          _Tag(
                            label: property.areaRange!,
                            icon: Icons.crop_square_rounded,
                          ),
                        if (property.listingCategory != null)
                          _Tag(
                            label: property.listingCategory!
                                .split("_")
                                .join(" ")
                                .capitalizeFirst!,
                            color: Colors.green,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price
                    AppText(
                      property.formattedPrice ??
                          (property.priceRange != null
                              ? "${property.priceRange!.min} – ${property.priceRange!.max}"
                              : "Price N/A"),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            // ── Fav icon ────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                (property.isFavorited ?? true)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const _Tag({required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: c),
            const SizedBox(width: 3),
          ],
          AppText(label, fontSize: 10, color: c, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
