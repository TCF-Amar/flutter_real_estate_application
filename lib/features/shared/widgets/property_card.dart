import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final bool featured;
  final VoidCallback? onFavoriteTap;

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
    required this.property,
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
        margin: const EdgeInsets.only(bottom: 10),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SECTION
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
                  child: property.image != null
                      ? Image.network(
                          property.image!,
                          fit: BoxFit.cover,
                          cacheHeight:
                              (170 * MediaQuery.of(context).devicePixelRatio)
                                  .toInt(),
                          errorBuilder: (context, error, stackTrace) =>
                              _PlaceholderImage(url: property.shareData.image),
                        )
                      : _PlaceholderImage(url: property.shareData.image),
                ),

                /// TAGS
                Positioned(
                  top: 20,
                  left: 20,
                  right: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        featured
                            ? const AppTag(
                                label: 'Featured',
                                color: Colors.blueAccent,
                                backgroundColor: Colors.white,
                              )
                            : AppTag(
                                label: property.listingCategory ?? '',
                                color: Colors.blueAccent,
                                backgroundColor: Colors.white,
                              ),
                        const SizedBox(width: 6),
                        AppTag(
                          label: property.propertyMode,
                          color: AppColors.grey,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        AppTag(
                          label: property.propertyType,
                          color: Colors.green,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                /// FAVORITE BUTTON
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () => onFavoriteTap?.call(),
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
                ),
              ],
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  AppText(
                    property.title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  /// LOCATION
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
                          '${property.locality ?? ''}${property.locality != null && property.city != null ? ', ' : ''}${property.city ?? ''}',
                          fontSize: 12,
                          color: AppColors.grey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// PRICE + SPECS
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          property.formattedPrice.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _SpecIcon(
                            icon: Assets.icons.bed,
                            value: property.bhkList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Assets.icons.bath,
                            value: property.bathroomList ?? '0',
                          ),
                          const SizedBox(width: 12),
                          _SpecIcon(
                            icon: Assets.icons.area,
                            value: (property.areaRange ?? '0')
                                .split(" - ")
                                .first,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(path: icon, height: 12, width: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Flexible(
          child: AppText(
            isArea ? "$value sq.ft" : value,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: AppColors.grey,
          ),
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
