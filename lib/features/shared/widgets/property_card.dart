import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class PropertyCard extends StatelessWidget {
  final Property item;
  final VoidCallback? onTap;
  const PropertyCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: false,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.toNamed(
          AppRoutes.propertyDetails,
          arguments: {'isFav': item.isFavorited.toString(), 'id': item.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Container(
                  height: 170,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: item.image != null
                      ? Image.network(
                          item.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _PlaceholderImage(url: item.shareData.image),
                        )
                      : _PlaceholderImage(url: item.shareData.image),
                ),
                // Tags
                Positioned(
                  top: 20,
                  left: 20,
                  child: Row(
                    children: [
                      _TagBadge(label: 'Featured', color: Colors.white),
                      const SizedBox(width: 6),
                      _TagBadge(
                        label: item.propertyMode
                            .toString()
                            .split("_")
                            .map((e) => e.capitalizeFirst!)
                            .join(" "),
                        color: Colors.white.withValues(alpha: 0.9),
                        textColor: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      _TagBadge(
                        label: item.propertyType
                            .split("_")
                            .map((e) => e.capitalizeFirst!)
                            .join(" "),
                        color: Colors.white.withValues(alpha: 0.9),
                        textColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      AppSnackbar.info("Added to favorites");
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          item.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: item.isFavorited
                              ? Colors.red
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          '${item.locality ?? ''}${item.locality != null && item.city != null ? ', ' : ''}${item.city ?? ''}',
                          fontSize: 12,
                          color: AppColors.grey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        "\$ ${item.basePrice}",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      Row(
                        children: [
                          _SpecIcon(
                            icon: Icons.bed_rounded,
                            value: item.bhkList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Icons.bathtub_outlined,
                            value: item.bathroomList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Icons.square_foot_outlined,
                            value: (item.areaRange ?? '0').split(" - ").first,
                            isArea: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  const _TagBadge({required this.label, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppText(
        label,
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: textColor ?? Colors.amber,
      ),
    );
  }
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isArea;
  const _SpecIcon({
    required this.icon,
    required this.value,
    this.isArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        AppText(
          isArea ? "$value sq.ft" : value,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColors.grey,
        ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final String url;
  const _PlaceholderImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade200,
        child: Icon(
          Icons.image_not_supported_rounded,
          color: AppColors.grey.withValues(alpha: 0.3),
          size: 40,
        ),
      ),
    );
  }
}
