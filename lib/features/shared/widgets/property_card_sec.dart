import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ModernPropertyCard extends StatelessWidget {
  final Property property;
  final bool? isSimilar;
  final VoidCallback? onToggleFavorite;
  const ModernPropertyCard({
    super.key,
    required this.property,
    this.isSimilar = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSimilar == true
            ? Get.find<PropertyDetailsController>().propertyId.value =
                  property.id
            : Get.toNamed(
                AppRoutes.propertyDetails,
                arguments: {'id': property.id},
              );
      },
      // margin: const EdgeInsets.all(0),
      child: SizedBox(
        height: 240,
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Stack(
          children: [
            /// PROPERTY IMAGE
            AppImage(
              path: property.media.images.isNotEmpty == true
                  ? property.media.images.first.url
                  : null,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

            /// GRADIENT OVERLAY
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            /// TOP TAGS
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppTag(
                        label: property.propertyType,
                        backgroundColor: Colors.white,
                        fontSize: 9,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      AppTag(
                        label: "${property.listingCategory}",
                        backgroundColor: Colors.white,
                        fontSize: 9,
                        color: Colors.amber,
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () => onToggleFavorite?.call(),
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 18,
                      child: AppSvg(
                        path: property.isFavorited == true
                            ? Assets.icons.heartSelected
                            : Assets.icons.heart,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM INFO CARD
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// TEXTS
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(property.title),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              AppSvg(path: Assets.icons.location),
                              const SizedBox(width: 4),
                              Flexible(
                                child: AppText(
                                  "${property.locality?.capitalize}, ${property.state?.capitalize}",
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      child: AppText(
                        "${property.formattedPrice}",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
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
