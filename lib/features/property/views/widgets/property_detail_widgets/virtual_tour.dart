import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VirtualTour extends StatelessWidget {
  const VirtualTour({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyDetailsController>();

    // find images with document type '360'
    final List<MediaItem> virtualTours =
        controller.propertyDetail?.media?.images
            .where((img) => img.documentType == '360')
            .toList() ??
        [];

    if (virtualTours.isEmpty) return const SizedBox();

    final url = virtualTours.first.url;
    return AppContainer(
      onTap: () => Get.dialog(AppPanoramaView(path: url)),
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.large("360° Virtual Tour"),
          AppContainer(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),

            height: 200,

            child: AppImage(
              path: url,
              // radius: BorderRadius.circular(8),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
