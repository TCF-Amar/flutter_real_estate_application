import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/my_booking/controllers/booking_details_controller.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookingHeaderSection extends StatelessWidget {
  final BookedPropertyDetail property;
  const BookingHeaderSection({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingDetailsController>();
    return FlexibleSpaceBar(
      background: AppContainer(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: property.images.isEmpty
              ? AppImage(path: "", fit: BoxFit.cover)
              : Obx(() {
                  return AppImage(
                    path: property.images[controller.currentImageIndex].url,
                    fit: BoxFit.cover,
                  );
                }),
        ),
      ),
    );
  }
}
