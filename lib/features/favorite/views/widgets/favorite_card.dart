import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteProperty property;

  const FavoriteCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.propertyDetails,
        arguments: {'id': property.id},
        preventDuplicates: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
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
              borderRadius: BorderRadius.circular(14),
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
                    Row(
                      children: [
                        if (property.listingCategory != null)
                          AppTag(
                            label: property.listingCategory!,
                            color: Colors.green,
                          ),
                        if (property.listingCategory != null)
                          const SizedBox(width: 6),
                        if (property.propertyType != null)
                          AppTag(
                            label: property.propertyType!,
                            color: AppColors.primary,
                          ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            controller.toggleFavorite(
                              type: "property",
                              propertyId: property.id!,
                            );
                            // controller.saveFavorite( );
                          },
                          child: Icon(
                            (property.isFavorited ?? true)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    // Title
                    AppText(
                      property.title ?? "Untitled Property",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      maxLines: 2,
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
                          child: property.city != null || property.state != null
                              ? AppText(
                                  [property.city, property.state]
                                      .where((e) => e != null && e.isNotEmpty)
                                      .join(", "),
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : AppText(
                                  "Location N/A",
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Row(
                      children: [
                        AppText(
                          property.formattedPrice ?? "N/A",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

           
          ],
        ),
      ),
    );
  }
}
