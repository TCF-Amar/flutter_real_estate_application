import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';

class MediaImages extends StatelessWidget {
  final Media media;
  const MediaImages({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: (media.images.isEmpty)
          ? const SizedBox.shrink()
          : Column(
              children: [
                //? images
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: media.images.length,
                    itemBuilder: (context, index) {
                      final image = media.images[index];
                      return GestureDetector(
                        onTap: () {
                          controller.updateCurrentIndex(index);
                        },
                        child: Obx(
                          () => Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withValues(alpha: 0.8),
                              border: Border.all(
                                width: controller.currentIndex == index ? 2 : 0,
                                color: controller.currentIndex == index
                                    ? AppColors.primary.withValues(alpha: 0.8)
                                    : Colors.transparent,
                              ),
                            ),
                            width: 70,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Container(
                                        // padding: const EdgeInsets.all(16),
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.hide_image_outlined,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          // size: 50,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //? image
                const SizedBox(height: 10),
                Row(
                  children: List.generate(
                    media.images.length,
                    (index) => Expanded(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.updateCurrentIndex(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            // margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 8,
                            decoration: BoxDecoration(
                              color: controller.currentIndex == index
                                  ? AppColors.primary.withValues(alpha: 0.8)
                                  : Colors.grey.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(index == 0 ? 10 : 0),
                                bottomLeft: Radius.circular(
                                  index == 0 ? 10 : 0,
                                ),
                                topRight: Radius.circular(
                                  index == media.images.length - 1 ? 10 : 0,
                                ),
                                bottomRight: Radius.circular(
                                  index == media.images.length - 1 ? 10 : 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
