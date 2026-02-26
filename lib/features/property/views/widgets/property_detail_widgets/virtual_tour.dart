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
            child: AppPanoramaView(path: url),
          ),
        ],
      ),
    );
  }
}
