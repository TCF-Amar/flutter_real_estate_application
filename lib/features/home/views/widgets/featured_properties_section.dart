import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/home/models/home_data_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

/// Featured Properties horizontal scrolling carousel using carousel_slider.
class FeaturedPropertiesSection extends StatefulWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  State<FeaturedPropertiesSection> createState() =>
      _FeaturedPropertiesSectionState();
}

class _FeaturedPropertiesSectionState extends State<FeaturedPropertiesSection> {
  int _currentPage = 0;
  final HomeController _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value &&
          _controller.featuredProperties.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (_controller.featuredProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      final items = _controller.featuredProperties;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
            child: AppText(
              'Featured Properties',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.black?.withValues(alpha: 0.70),
            ),
          ),

          // Carousel Slider
          CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (context, index, realIndex) =>
                _FeaturedCard(item: items[index]),
            options: CarouselOptions(
              height: 160,
              viewportFraction: 0.88,
              enlargeCenterPage: false,
              enableInfiniteScroll: items.length > 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeInOut,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),

          // Dot indicators
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.primary
                      : AppColors.black?.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _FeaturedCard extends StatelessWidget {
  final Property item;
  const _FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.propertyDetails, arguments: {'id': item.id}),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (item.image != null)
              Image.network(
                item.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: Image.network(
                    item.shareData.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_rounded,
                        color: AppColors.grey?.withValues(alpha: 0.5),
                        size: 50,
                      );
                    },
                  ),
                ),
              )
            else
              Container(color: Colors.grey.shade300),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.background],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Info overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          item.title,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AppText(
                                '${item.locality ?? ''}${item.locality != null && item.city != null ? ', ' : ''}${item.city ?? ''}',
                                color: Colors.white70,
                                fontSize: 12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: AppText(
                      "\$ ${item.basePrice}",
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
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
