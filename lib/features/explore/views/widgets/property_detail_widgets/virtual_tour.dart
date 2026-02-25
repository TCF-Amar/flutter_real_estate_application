import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/controllers/property_details_controller.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

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
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "360° Virtual Tour"),
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,

            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PanoramaViewer(
                child: Image.network(

                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey.withValues(alpha: 0.8),
                      child: const Icon(
                        Icons.hide_image_outlined,
                        size: 40,
                        color: Colors.white,
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
