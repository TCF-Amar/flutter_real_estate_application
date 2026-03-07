import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_image.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

// Cached const gradient — avoids re-allocating on every _FeaturedCard build
const _cardGradient = LinearGradient(
  colors: [Colors.transparent, AppColors.background],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// Featured Properties horizontal scrolling carousel using carousel_slider.
class FeaturedPropertiesSection extends StatelessWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoading.value && controller.featuredProperties.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.featuredProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      final items = controller.featuredProperties;

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
              color: AppColors.black.withValues(alpha: 0.70),
            ),
          ),

          // Carousel Slider + Dots — wrapped in _CarouselWithDots so that
          // page changes only rebuild the dots row, not the entire Obx section.
          _CarouselWithDots(items: items),
        ],
      );
    });
  }
}

/// Owns the carousel page state so `setState` only redraws the dots row,
/// not the parent Obx block.
class _CarouselWithDots extends StatefulWidget {
  final List<Property> items;
  const _CarouselWithDots({required this.items});

  @override
  State<_CarouselWithDots> createState() => _CarouselWithDotsState();
}

class _CarouselWithDotsState extends State<_CarouselWithDots> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) =>
              _FeaturedCard(item: widget.items[index]),
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.88,
            enlargeCenterPage: false,
            enableInfiniteScroll: widget.items.length > 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              setState(() => _currentPage = index);
            },
          ),
        ),

        // Dot indicators — only this widget rebuilds on page change
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.primary
                    : AppColors.black.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
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
            // Background image — cacheWidth/cacheHeight limit decode size
            if (item.image != null)
              AppImage(path: item.image)
            else
              Container(color: Colors.grey.shade300),

            // Gradient overlay — uses the cached const
            const DecoratedBox(
              decoration: BoxDecoration(gradient: _cardGradient),
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
