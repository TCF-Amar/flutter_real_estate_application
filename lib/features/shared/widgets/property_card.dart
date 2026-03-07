import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyCard extends StatelessWidget {
  final Property item;
  final VoidCallback? onTap;
  final bool featured;
  final VoidCallback? onFavoriteTap;

  // BoxDecoration is const-cacheable since shadow/radius/color never change.
  // The withValues alpha on black is computed at const-eval time via the
  // literal RGBA: black @ 4% opacity = rgba(0,0,0,0.04).
  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        blurRadius: 15,
        offset: Offset(0, 8),
      ),
    ],
  );

  const PropertyCard({
    super.key,
    required this.item,
    this.onTap,
    this.featured = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: false,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => onTap?.call(),
      child: Container(
        decoration: _cardDecoration,
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
                          // Decode at display size — 170px height, full width
                          cacheHeight:
                              (170 * MediaQuery.of(context).devicePixelRatio)
                                  .toInt(),
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
                      featured
                          ? AppTag(
                              label: 'Featured',
                              color: Colors.blueAccent,
                              backgroundColor: Colors.white,
                            )
                          : AppTag(
                              label: item.listingCategory ?? '',
                              color: Colors.blueAccent,
                              backgroundColor: Colors.white,
                            ),
                      const SizedBox(width: 6),
                      AppTag(
                        label: item.propertyMode,
                        color: AppColors.grey,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      AppTag(
                        label: item.propertyType,
                        color: Colors.green,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () => onFavoriteTap?.call(),
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
                          color: AppColors.primary,
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
                    // maxLines: 1,
                    overflow: TextOverflow.visible,
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
                        "${item.formattedPrice}",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      Row(
                        children: [
                          _SpecIcon(
                            icon: Assets.icons.bed,
                            value: item.bhkList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Assets.icons.bath,
                            value: item.bathroomList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Assets.icons.area,
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

class _SpecIcon extends StatelessWidget {
  final String icon;
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
        AppSvg(path: icon, height: 12, width: 12, color: AppColors.primary),
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
