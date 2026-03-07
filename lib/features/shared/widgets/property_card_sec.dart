import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ModernPropertyCard extends StatelessWidget {
  final Property property;

  const ModernPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.propertyDetails,
        arguments: {"id": property.id},
      ),
      // margin: const EdgeInsets.all(0),
      child: SizedBox(
        height: 240,
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Stack(
          children: [
            /// PROPERTY IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                path: property.media.images.isNotEmpty == true
                    ? property.media.images.first.url
                    : null,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
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
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 18,
                      child: AppSvg(
                        path: Assets.icons.heart,
                        width: 18,
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
                  children: [
                    /// TEXTS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "${property.locality}, ${property.state}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// PRICE
                    Text(
                      "${property.formattedPrice}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
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
