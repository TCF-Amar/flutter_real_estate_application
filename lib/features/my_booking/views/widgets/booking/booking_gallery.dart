import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/booking_details_controller.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';

import '../../../../shared/widgets/index.dart';

class BookingGallery extends StatelessWidget {
  final BookedPropertyDetail property;
  const BookingGallery({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingDetailsController>();
    if (property.images.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final image = property.images[index];
                  return Obx(
                    () => AppContainer(
                      onTap: () {
                        controller.onImageTap(index);
                      },
                      width: 70,
                      clipContent: true,
                      showBorder: true,
                      borderWidth: controller.currentImageIndex == index
                          ? 2
                          : 0,
                      borderColor: controller.currentImageIndex == index
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: AppImage(path: image.url, fit: BoxFit.cover),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: property.images.length,
              ),
            ),
            const SizedBox(height: 10),
            if (property.images.length > 1)
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: property.images.asMap().entries.map((entry) {
                    final index = entry.key;
                    final isActive = controller.currentImageIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isActive ? 30 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                );
              }),
          ],
        ),
      ),
    );
  }
}
