import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SimilarProperties extends StatefulWidget {
  const SimilarProperties({super.key});

  @override
  State<SimilarProperties> createState() => _SimilarPropertiesState();
}

class _SimilarPropertiesState extends State<SimilarProperties> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();

    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Similar Properties"),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingSimilar) {
              return const SizedBox(
                height: 280,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (controller.similarProperties.isEmpty) {
              return const SizedBox(
                height: 120,
                child: Center(
                  child: AppText(
                    "No similar properties found",
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.similarProperties.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: SimilarPropertyCard(
                      property: controller.similarProperties[index],
                    ),
                  );
                },
              ),
            );
          }),

          // ── Page-indicator dots ──────────────────────────────
          Obx(() {
            final count = controller.similarProperties.length;
            if (count == 0) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 8, right: 4),
                  height: 7,
                  width: active ? 18 : 7,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class SimilarPropertyCard extends StatelessWidget {
  final Property property;

  const SimilarPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    final imageUrl = property.media.images.isNotEmpty
        ? property.media.images.first.url
        : null;

    return GestureDetector(
      onTap: () {
        controller.propertyId.value = property.id;
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ── Background Image ─────────────────────────────
              Positioned.fill(
                child: imageUrl != null
                    ? AppImage(path: imageUrl)
                    : _PlaceholderImage(),
              ),

              // ── Gradient overlay ─────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.55),
                      ],
                      stops: const [0.3, 0.55, 1.0],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (property.listingCategory != null)
                      // Flexible(
                      AppTag(
                        label: property.listingCategory!,
                        color: Colors.redAccent,
                        backgroundColor: Colors.white,
                      ),
                    SizedBox(width: 6),
                    // ),
                    if (property.propertyType.isNotEmpty)
                      AppTag(
                        label: property.propertyType,
                        color: Colors.amber,
                        backgroundColor: Colors.white,
                      ),
                    const Spacer(),
                    _FavButton(isFav: property.isFavorited),
                  ],
                ),
              ),

              // ── Bottom info panel ─────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      AppText(
                        property.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // Locality
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: AppText(
                              _locality(property),
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Stats row + price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Chips — flexible so they never overflow
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              // physics: const NeverScrollableScrollPhysics(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (property.bhkList != null &&
                                      property.bhkList!.isNotEmpty)
                                    _StatChip(
                                      icon: Assets.icons.bed,
                                      label: property.bhkList!,
                                      color: Colors.indigo.shade100,
                                      iconColor: Colors.indigo,
                                    ),
                                  if (property.bathroomList != null &&
                                      property.bathroomList!.isNotEmpty)
                                    _StatChip(
                                      icon: Assets.icons.bath,
                                      label: property.bathroomList!,
                                      color: Colors.teal.shade50,
                                      iconColor: Colors.teal,
                                    ),
                                  if (property.areaRange != null &&
                                      property.areaRange!.isNotEmpty)
                                    _StatChip(
                                      icon: Assets.icons.area,
                                      label: property.areaRange!,
                                      color: Colors.orange.shade50,
                                      iconColor: Colors.orange,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // Price — pinned to the right
                          AppText(
                            property.formattedPrice ?? "—",
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  String _locality(Property p) {
    final parts = [
      p.locality,
      p.city,
    ].where((e) => e != null && e.isNotEmpty).toList();
    return parts.join(', ');
  }
}

/// Small tag chip shown in upper-left of the card.
class _FavButton extends StatelessWidget {
  final bool isFav;

  const _FavButton({required this.isFav});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.find<PropertyController>().updateFavoriteData(property.id!);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? AppColors.error : AppColors.primary,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final Color iconColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvg(path: icon, height: 12, width: 12, color: iconColor),
          const SizedBox(width: 4),
          AppText(label, fontSize: 8, color: iconColor),
        ],
      ),
    );
  }
}

/// Subtle gradient placeholder when there is no image.
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.4),
            AppColors.background.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.home_work_outlined, size: 64, color: Colors.white38),
      ),
    );
  }
}
