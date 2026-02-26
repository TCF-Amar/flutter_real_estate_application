import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class HeaderSection extends StatelessWidget {
  // final PropertyDetail property;
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();
    final property = controller.propertyDetail;

    return property!.media?.images.isNotEmpty ?? false
        ? FlexibleSpaceBar(
            background: Obx(() {
              final currentIndex = controller.currentIndex;
              final images = property.media!.images;
              final image = (images.isNotEmpty && currentIndex < images.length)
                  ? images[currentIndex]
                  : null;

              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Image.network(
                      image?.url ?? property.shareData?.image.toString() ?? "",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            property.shareData?.image.toString() ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.hide_image_outlined,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    // left: 0,
                    right: 10,
                    child: Obx(
                      () => Container(
                        // height: 100,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppText(
                          "${controller.currentIndex + 1}/${property.media?.images.length ?? 0}",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              controller.previous();
                            },
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              controller.next();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
        : FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Image.network(
                property.shareData?.image.toString() ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.hide_image_outlined,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
