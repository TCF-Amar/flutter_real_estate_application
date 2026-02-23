import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/project_overview_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class LatestUpdate extends StatefulWidget {
  final LatestUpdateModel update;
  const LatestUpdate({super.key, required this.update});

  @override
  State<LatestUpdate> createState() => _LatestUpdateState();
}

class _LatestUpdateState extends State<LatestUpdate> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   if ((widget.update.images?.length ?? 0) <= 0) {
  //     // add images for demonstration if empty
  //     widget.update.images?.addAll([
  //       "https://res.cloudinary.com/dnhvzcxfw/image/upload/v1770975917/chat_images/edited_1770975912889_xrlluz.jpg",
  //       "https://res.cloudinary.com/dnhvzcxfw/image/upload/v1770975917/chat_images/edited_1770975912889_xrlluz.jpg",
  //       "https://res.cloudinary.com/dnhvzcxfw/image/upload/v1770975917/chat_images/edited_1770975912889_xrlluz.jpg",
  //     ]);
  //   }
  // }

  void _nextPage() {
    _carouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _carouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Latest Update"),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSlider(),
                const SizedBox(height: 12),
                AppText(
                  widget.update.date ?? "N/A",
                  fontSize: 11,
                  color: AppColors.grey,
                ),
                const SizedBox(height: 6),
                AppText(
                  widget.update.title ?? "Update",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 6),
                AppText(
                  widget.update.description ?? "",
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    final images = widget.update.images ?? [];
    if (images.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: images.length,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            autoPlay: true,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Image.network(
              images[index],
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(Icons.broken_image, color: AppColors.grey),
                  ),
                );
              },
            );
          },
        ),
        if (images.length > 1) ...[
          // Previous Button
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: _buildNavButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: _previousPage,
            ),
          ),

          // Next Button
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: _buildNavButton(
              icon: Icons.arrow_forward_ios,
              onPressed: _nextPage,
            ),
          ),
          // Page Indicator
          Positioned(
            bottom: 8,
            right: 0,
            left: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
