import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

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
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,

                    itemCount: media.images.length,
                    itemBuilder: (context, index) {
                      final image = media.images[index];
                      return GestureDetector(
                        onTap: () {
                          controller.updateCurrentIndex(index);
                        },
                        child: Obx(
                          () => AppContainer(
                            margin: const EdgeInsets.only(right: 10),

                            color: Colors.grey.withValues(alpha: 0.8),
                            border: Border.all(
                              width: controller.currentIndex == index ? 2 : 0,
                              color: controller.currentIndex == index
                                  ? AppColors.primary.withValues(alpha: 0.8)
                                  : Colors.transparent,
                            ),
                            width: 70,
                            height: 70,
                            child: AppImage(
                              path: image.url,
                              radius: BorderRadius.circular(10),
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
